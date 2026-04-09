import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FitChecksScreen extends StatefulWidget {
  const FitChecksScreen({super.key});

  @override
  State<FitChecksScreen> createState() => _FitChecksScreenState();
}

class _FitChecksScreenState extends State<FitChecksScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder(
        future: Supabase.instance.client.from('fit_checks').select('*, stores(*)').order('created_at', ascending: false),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          
          final List<dynamic> posts = snapshot.data ?? [];
          
          if (posts.isEmpty) {
            return const Center(child: Text("No Fit Checks yet! Upload yours."));
          }

          return MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            padding: const EdgeInsets.all(8),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              final store = post['stores'];
              return Card(
                clipBehavior: Clip.antiAlias,
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(
                      imageUrl: post['image_url'],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const SizedBox(height: 150, child: Center(child: CircularProgressIndicator())),
                      errorWidget: (context, url, error) => const SizedBox(height: 150, child: Icon(Icons.error)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('@user', style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          if (store != null)
                             ActionChip(
                               label: Text(store['name'], style: const TextStyle(fontSize: 10)),
                               avatar: const Icon(Icons.location_on, size: 14),
                               onPressed: () {
                                 // Ideally navigate back to map or detail
                               },
                             )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add_a_photo),
        label: const Text('Post Fit'),
        onPressed: () {
          // TODO: Implement image_picker upload pipeline
           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Camera integration pending!')));
        },
      ),
    );
  }
}
