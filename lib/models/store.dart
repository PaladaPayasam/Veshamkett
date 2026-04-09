// lib/models/store.dart

/// Represents a Kerala District where a store can be located.
enum District {
  thiruvananthapuram(displayName: 'Thiruvananthapuram'),
  kollam(displayName: 'Kollam'),
  pathanamthitta(displayName: 'Pathanamthitta'),
  alappuzha(displayName: 'Alappuzha'),
  kottayam(displayName: 'Kottayam'),
  idukki(displayName: 'Idukki'),
  ernakulam(displayName: 'Ernakulam'),
  thrissur(displayName: 'Thrissur'),
  palakkad(displayName: 'Palakkad'),
  malappuram(displayName: 'Malappuram'),
  kozhikode(displayName: 'Kozhikode'),
  wayanad(displayName: 'Wayanad'),
  kannur(displayName: 'Kannur'),
  kasaragod(displayName: 'Kasaragod');

  final String displayName;
  const District({required this.displayName});

  /// Helper to convert string from DB to Enum
  static District fromString(String name) {
    return District.values.firstWhere(
      (d) => d.name.toLowerCase() == name.toLowerCase(),
      orElse: () => District.ernakulam, // default fallback
    );
  }
}

/// Represents the category of the store.
enum StoreCategory {
  thrift(displayName: 'Thrift'),
  surplus(displayName: 'Surplus'),
  retail(displayName: 'Retail Chain');
  
  final String displayName;
  const StoreCategory({required this.displayName});

  static StoreCategory fromString(String name) {
    return StoreCategory.values.firstWhere(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
      orElse: () => StoreCategory.thrift,
    );
  }
}

/// Store model corresponding to the Supabase 'stores' table schema.
class Store {
  final String id;
  final String name;
  final double? latitude;
  final double? longitude;
  final District district;
  final StoreCategory category;
  final String? instagramHandle;
  final String? websiteUrl;
  final bool isOnlineOnly;
  final String? styleDescription;
  final String? profileImageUrl;
  final DateTime createdAt;
  final double? averageRating;
  final int reviewCount;

  Store({
    required this.id,
    required this.name,
    this.latitude,
    this.longitude,
    required this.district,
    required this.category,
    this.instagramHandle,
    this.websiteUrl,
    this.isOnlineOnly = false,
    this.styleDescription,
    this.profileImageUrl,
    required this.createdAt,
    this.averageRating,
    this.reviewCount = 0,
  });

  /// Factory method to create a [Store] from Supabase JSON data.
  factory Store.fromJson(Map<String, dynamic> json) {
    double? avgRating;
    int count = 0;
    if (json['reviews'] != null && json['reviews'] is List) {
      final List reviews = json['reviews'];
      if (reviews.isNotEmpty) {
        count = reviews.length;
        int sum = 0;
        for (var r in reviews) { sum += (r['rating'] as int?) ?? 5; }
        avgRating = sum / count;
      }
    }

    return Store(
      id: json['id'] as String,
      name: json['name'] as String,
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      district: District.fromString(json['district'] as String),
      category: StoreCategory.fromString(json['category'] as String),
      instagramHandle: json['instagram_handle'] as String?,
      websiteUrl: json['website_url'] as String?,
      isOnlineOnly: json['is_online_only'] as bool? ?? false,
      styleDescription: json['style_description'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      averageRating: avgRating,
      reviewCount: count,
    );
  }

  /// Converts the [Store] instance to JSON for Supabase mutations.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'district': district.name,
      'category': category.name,
      'instagram_handle': instagramHandle,
      'website_url': websiteUrl,
      'is_online_only': isOnlineOnly,
      'style_description': styleDescription,
      'profile_image_url': profileImageUrl,
      // 'created_at' usually auto-handled by Supabase DB via default now()
    };
  }
}
