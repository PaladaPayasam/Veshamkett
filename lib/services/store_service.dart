import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store.dart';

class StoreService {
  final _supabase = Supabase.instance.client;

  Future<List<Store>>? _fetchFuture;

  Future<List<Store>> getStores() {
    _fetchFuture ??= _supabase.from('stores').select('*, reviews(rating)').then((response) {
      return (response as List<dynamic>).map((json) => Store.fromJson(json)).toList();
    }).catchError((e) {
      print('Error fetching stores: $e');
      return <Store>[];
    });
    return _fetchFuture!;
  }
}
