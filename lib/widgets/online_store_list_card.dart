import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/store.dart';

class OnlineStoreListCard extends StatelessWidget {
  final Store store;

  const OnlineStoreListCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final String districtName = store.district.displayName;
    final String vibeText = store.styleDescription ?? 'Curated ${store.category.displayName} fashion from $districtName';

    return Card(
      elevation: 2,
      color: colorScheme.surface,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            store.profileImageUrl != null
              ? CircleAvatar(
                  radius: 35,
                  backgroundImage: NetworkImage(store.profileImageUrl!),
                )
              : CircleAvatar(
                  radius: 35,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade800 : Colors.grey.shade200,
                  child: Icon(Icons.storefront, color: Colors.grey.shade500, size: 30),
                ),
            const SizedBox(width: 16),
            
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    store.name,
                    style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      Text(store.averageRating != null ? " ${store.averageRating!.toStringAsFixed(1)}" : " New", style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                      if (store.reviewCount > 0)
                        Text(" (${store.reviewCount})", style: textTheme.labelSmall?.copyWith(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    vibeText,
                    style: textTheme.bodyMedium?.copyWith(color: Theme.of(context).brightness == Brightness.dark ? Colors.grey.shade400 : Colors.grey.shade700),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      _buildMiniBadge(store.category.displayName, store.category == StoreCategory.thrift ? colorScheme.primary.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
                      store.category == StoreCategory.thrift ? colorScheme.primary : Colors.orange),
                      if (store.isOnlineOnly) _buildMiniBadge('Online 📦', Colors.purple.withOpacity(0.15), Colors.purple),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            
            if (!store.isOnlineOnly && store.latitude != null && store.longitude != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: _buildDirectionsButton(store.latitude!, store.longitude!, Theme.of(context).colorScheme.primary),
              ),
            if (store.instagramHandle != null && store.instagramHandle!.isNotEmpty)
              _buildInstagramButton(store.instagramHandle!)
            else if (store.websiteUrl != null && store.websiteUrl!.isNotEmpty)
              _buildWebsiteButton(store.websiteUrl!)
          ],
        ),
      ),
    );
  }

  Widget _buildDirectionsButton(double lat, double lng, Color bgColor) {
    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.directions, color: Colors.white),
        onPressed: () async {
          final url = Uri.parse('https://www.google.com/maps/dir/?api=1&destination=$lat,$lng');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }

  Widget _buildMiniBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textColor)),
    );
  }

  Widget _buildInstagramButton(String handle) {
    return Container(
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFFf09433), Color(0xFFe6683c), Color(0xFFdc2743), Color(0xFFcc2366), Color(0xFFbc1888)],
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
      ),
      child: IconButton(
        icon: const Icon(Icons.photo_camera, color: Colors.white),
        onPressed: () async {
          final cleanHandle = handle.replaceAll('@', '');
          final url = Uri.parse('https://www.instagram.com/$cleanHandle');
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }

  Widget _buildWebsiteButton(String websiteUrl) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.language, color: Colors.white),
        onPressed: () async {
          final url = Uri.parse(websiteUrl);
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          }
        },
      ),
    );
  }
}
