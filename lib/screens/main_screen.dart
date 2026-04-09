import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../main.dart'; // Access themeNotifier
import 'map_screen.dart';
import 'online_store_list_screen.dart';
import 'fit_checks_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  void _showQuestModal(BuildContext context) async {
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Log in to see your Quests!')));
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return FutureBuilder(
          future: Supabase.instance.client.from('user_achievements').select().eq('user_id', session.user.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final list = snapshot.data as List<dynamic>? ?? [];
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Thrift Quest Badges', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  if (list.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No badges earned yet. Go check in to physical stores within 50m to unlock achievements!', textAlign: TextAlign.center),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            leading: const Icon(Icons.local_police, color: Colors.amber, size: 32),
                            title: Text(list[index]['badge_type'], style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: const Text('Unlocked!'),
                          );
                        },
                      ),
                    )
                ],
              ),
            );
          }
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Veshamkett 🍃', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          actions: [
            IconButton(
               icon: const Icon(Icons.military_tech, color: Colors.amber),
               onPressed: () => _showQuestModal(context),
            ),
            ValueListenableBuilder<ThemeMode>(
              valueListenable: themeNotifier,
              builder: (context, currentMode, _) {
                bool isDark = currentMode == ThemeMode.dark || 
                    (currentMode == ThemeMode.system && Theme.of(context).brightness == Brightness.dark);
                return IconButton(
                   icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
                   onPressed: () {
                     themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                   },
                );
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: Theme.of(context).colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [
              Tab(icon: Icon(Icons.map_outlined), text: 'Local Map'),
              Tab(icon: Icon(Icons.storefront_outlined), text: 'Online Shops'),
              Tab(icon: Icon(Icons.camera_alt_outlined), text: 'Fit Checks'),
            ],
          ),
        ),
        body: const TabBarView(
          physics: NeverScrollableScrollPhysics(), // Prevent horizontal swipe to avoid conflicts with map panning
          children: [
            MapScreen(),
            OnlineStoreListScreen(),
            FitChecksScreen(),
          ],
        ),
      ),
    );
  }
}
