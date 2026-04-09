import 'package:flutter/material.dart';
import '../models/store.dart';
import '../services/store_service.dart';
import '../widgets/online_store_list_card.dart';

class OnlineStoreListScreen extends StatefulWidget {
  const OnlineStoreListScreen({super.key});

  @override
  State<OnlineStoreListScreen> createState() => _OnlineStoreListScreenState();
}

class _OnlineStoreListScreenState extends State<OnlineStoreListScreen> {
  final StoreService _storeService = StoreService();
  List<Store> _onlineStores = [];
  bool _isLoading = true;
  bool _sortByTopRated = false;

  void _applySort() {
    setState(() {
      _sortByTopRated = !_sortByTopRated;
      if (_sortByTopRated) {
        _onlineStores.sort((a, b) => (b.averageRating ?? 0).compareTo(a.averageRating ?? 0));
      } else {
        _onlineStores.sort((a, b) => a.name.compareTo(b.name));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadStores();
  }

  Future<void> _loadStores() async {
    final stores = await _storeService.getStores();
    if (mounted) {
      setState(() {
        _onlineStores = stores
            .where((s) =>
                s.isOnlineOnly ||
                (s.instagramHandle != null && s.instagramHandle!.isNotEmpty))
            .toList();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_onlineStores.isEmpty) {
      return const Center(
        child: Text(
          'No online shops found.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              FilterChip(
                label: const Text('Top Rated ★'),
                selected: _sortByTopRated,
                onSelected: (val) => _applySort(),
                selectedColor: Colors.amber.shade200,
                backgroundColor: Theme.of(context).colorScheme.surface,
              )
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _onlineStores.length,
            itemBuilder: (context, index) {
              final store = _onlineStores[index];
              return OnlineStoreListCard(store: store);
            },
          ),
        ),
      ],
    );
  }
}
