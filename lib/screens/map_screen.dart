import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/store_service.dart';
import '../models/store.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  final PageController _pageController = PageController(viewportFraction: 0.85);
  final TextEditingController _searchController = TextEditingController();
  final StoreService _storeService = StoreService();
  
  // Coordinates for Kerala Center point
  final LatLng _keralaCenter = const LatLng(10.8505, 76.2711);

  List<Store> _allPhysicalStores = [];
  List<Store> _filteredStores = [];
  bool _isLoading = true;

  String _searchQuery = '';
  String _selectedCategory = 'All';

  final List<String> _categories = ['All', 'Thrift', 'Surplus', 'Vintage', 'Streetwear'];

  @override
  void initState() {
    super.initState();
    _loadStores();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      _applyFilters();
    });
  }

  Future<void> _loadStores() async {
    final stores = await _storeService.getStores();
    setState(() {
      _allPhysicalStores = stores.where((s) => !s.isOnlineOnly && s.latitude != null && s.longitude != null).toList();
      _filteredStores = List.from(_allPhysicalStores);
      _isLoading = false;
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredStores = _allPhysicalStores.where((store) {
        bool matchesCategory = true;
        if (_selectedCategory != 'All') {
          if (_selectedCategory == 'Thrift') {
            matchesCategory = store.category == StoreCategory.thrift;
          } else if (_selectedCategory == 'Surplus') {
            matchesCategory = store.category == StoreCategory.surplus;
          } else {
            final vibe = store.styleDescription?.toLowerCase() ?? '';
            matchesCategory = vibe.contains(_selectedCategory.toLowerCase());
          }
        }
        
        bool matchesSearch = true;
        if (_searchQuery.isNotEmpty) {
          final query = _searchQuery.toLowerCase();
          matchesSearch = store.name.toLowerCase().contains(query) || 
                          store.district.displayName.toLowerCase().contains(query);
        }

        return matchesCategory && matchesSearch;
      }).toList();
    });
  }

  void _onCategorySelected(String category) {
    HapticFeedback.lightImpact();
    setState(() {
      _selectedCategory = category;
    });
    _applyFilters();
    if (_filteredStores.isNotEmpty) {
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
      _mapController.move(LatLng(_filteredStores[0].latitude!, _filteredStores[0].longitude!), 14.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          // BASE LAYER: Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _keralaCenter,
              initialZoom: 7.0,
              maxZoom: 18.0,
              minZoom: 6.0,
            ),
            children: [
              TileLayer(
                urlTemplate: isDark 
                    ? 'https://{s}.basemaps.cartocdn.com/rastertiles/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.veshamkett',
              ),
              MarkerLayer(
                markers: _filteredStores.map((store) {
                  final index = _filteredStores.indexOf(store);
                  
                  IconData categoryIcon = Icons.checkroom;
                  if (store.category == StoreCategory.surplus) categoryIcon = Icons.inventory_2;
                  if (store.category == StoreCategory.retail) categoryIcon = Icons.stars;
                  
                  return Marker(
                    point: LatLng(store.latitude!, store.longitude!),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                         HapticFeedback.lightImpact();
                         if (_pageController.hasClients) {
                           _pageController.animateToPage(
                             index, 
                             duration: const Duration(milliseconds: 300), 
                             curve: Curves.easeInOut
                           );
                         }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                           shape: BoxShape.circle,
                           border: Border.all(color: colorScheme.surface, width: 2),
                           color: colorScheme.primary, // Forest Green
                           boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
                        ),
                        child: Icon(
                          categoryIcon,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          
          // TOP LAYER: Search & Filters
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(color: isDark ? Colors.black54 : Colors.black12, blurRadius: 20, offset: const Offset(0, 5)),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: 'Search stores in Kerala...',
                          hintStyle: textTheme.bodyLarge?.copyWith(color: Colors.grey),
                          prefixIcon: const Icon(Icons.search, color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                        ),
                      ),
                    ),
                  ),
                  // Filters Bar
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: _categories.map((category) {
                        final isSelected = _selectedCategory == category;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(category, style: textTheme.bodyMedium?.copyWith(
                              color: isSelected ? Colors.white : colorScheme.onSurface,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            )),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              if (selected) _onCategorySelected(category);
                            },
                            selectedColor: colorScheme.primary,
                            backgroundColor: colorScheme.surface,
                            side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey.withOpacity(0.3)),
                            elevation: isSelected ? 4 : 2,
                            shadowColor: Colors.black26,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // BOTTOM LAYER: Store Carousel
          if (!_isLoading && _filteredStores.isNotEmpty)
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 250,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _filteredStores.length,
                    onPageChanged: (int index) {
                      HapticFeedback.lightImpact();
                      final store = _filteredStores[index];
                      _mapController.move(LatLng(store.latitude!, store.longitude!), 14.0);
                    },
                    itemBuilder: (context, index) {
                      final store = _filteredStores[index];
                      final imageUrl = store.profileImageUrl;
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(24.0),
                          boxShadow: [
                            BoxShadow(color: isDark ? Colors.black54 : Colors.black26, blurRadius: 15, offset: const Offset(0, 8)),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Top Half - Image
                              Expanded(
                                flex: 3,
                                child: imageUrl != null 
                                    ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Container(color: isDark ? Colors.grey.shade800 : Colors.grey.shade200, child: const Icon(Icons.image_not_supported)),
                                      )
                                    : Container(
                                        color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                                        child: Center(child: Icon(Icons.storefront, size: 48, color: Colors.grey.shade500)),
                                      ),
                              ),
                              // Bottom Half - Details
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Stack(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Row(
                                             children: [
                                                Container(
                                                   padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                   decoration: BoxDecoration(color: colorScheme.secondary.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
                                                   child: Text("OPEN", style: textTheme.labelSmall?.copyWith(color: colorScheme.secondary, fontWeight: FontWeight.bold)),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.star, color: Colors.orange, size: 14),
                                                Text(store.averageRating != null ? " ${store.averageRating!.toStringAsFixed(1)}" : " New", style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                                                if (store.reviewCount > 0)
                                                  Text(" (${store.reviewCount})", style: textTheme.labelSmall?.copyWith(color: Colors.grey)),
                                             ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            store.name,
                                            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.location_on, size: 14, color: Colors.grey),
                                              const SizedBox(width: 4),
                                              Text(
                                                store.district.displayName,
                                                style: textTheme.bodyMedium?.copyWith(color: Colors.grey.shade700),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Check-In Button (Thrift Quest)
                                            Container(
                                              margin: const EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.amber.shade600,
                                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                                              ),
                                              child: IconButton(
                                                icon: const Icon(Icons.explore, color: Colors.white, size: 20),
                                                onPressed: () => _handleCheckIn(store),
                                              ),
                                            ),
                                            // Directions Button
                                            Container(
                                              margin: store.instagramHandle != null && store.instagramHandle!.isNotEmpty 
                                                  ? const EdgeInsets.only(right: 8) 
                                                  : EdgeInsets.zero,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: colorScheme.primary,
                                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                                              ),
                                              child: IconButton(
                                                icon: const Icon(Icons.directions, color: Colors.white, size: 20),
                                                onPressed: () async {
                                                  final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=${store.latitude},${store.longitude}');
                                                  if (await canLaunchUrl(url)) {
                                                    await launchUrl(url, mode: LaunchMode.externalApplication);
                                                  }
                                                },
                                              ),
                                            ),
                                            // Instagram Button
                                            if (store.instagramHandle != null && store.instagramHandle!.isNotEmpty)
                                              Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  gradient: LinearGradient(
                                                    colors: [Color(0xFFf09433), Color(0xFFe6683c), Color(0xFFdc2743), Color(0xFFcc2366), Color(0xFFbc1888)],
                                                    begin: Alignment.bottomLeft,
                                                    end: Alignment.topRight,
                                                  ),
                                                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                                                ),
                                                child: IconButton(
                                                  icon: const Icon(Icons.photo_camera, color: Colors.white, size: 20),
                                                  onPressed: () async {
                                                    final handle = store.instagramHandle!.replaceAll('@', '');
                                                    final url = Uri.parse('https://www.instagram.com/$handle');
                                                    if (await canLaunchUrl(url)) {
                                                      await launchUrl(url, mode: LaunchMode.externalApplication);
                                                    }
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          
          if (_isLoading)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      floatingActionButton: Padding(
         padding: const EdgeInsets.only(bottom: 250), // clear carousel
         child: FloatingActionButton(
           onPressed: _moveToCurrentLocation,
           backgroundColor: colorScheme.surface,
           child: Icon(Icons.my_location, color: colorScheme.onSurface),
         ),
      ),
    );
  }

  Future<void> _moveToCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location services are disabled.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied.')));
        return;
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are permanently denied.')));
      return;
    } 

    final position = await Geolocator.getCurrentPosition();
    _mapController.move(LatLng(position.latitude, position.longitude), 14.0);
  }

  Future<void> _handleCheckIn(Store store) async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please log in to Check In!')));
      return;
    }

    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission required.')));
        return;
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      final distance = Geolocator.distanceBetween(
        position.latitude, position.longitude,
        store.latitude!, store.longitude!
      );

      if (distance > 50) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are ${distance.toInt()}m away. Get within 50 meters to Check In!')));
        return;
      }

      await Supabase.instance.client.from('user_achievements').insert({
        'user_id': session.user.id,
        'badge_type': 'Visited ${store.name}',
      });

      if(mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🎉 Checked In! Badge unlocked!')));
        HapticFeedback.vibrate();
      }
    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Already checked in to this store.')));
    }
  }
}
