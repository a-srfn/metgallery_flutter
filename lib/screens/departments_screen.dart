import 'package:flutter/material.dart';
import '../services/met_api_service.dart';
import 'artworks_screen.dart';
import 'offline_library_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  late Future<List<dynamic>> departmentsFuture;

  @override
  void initState() {
    super.initState();

    departmentsFuture =
        MetApiService.fetchDepartments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("MetGallery"),
        actions: [

          IconButton(

            icon: const Icon(
              Icons.bookmark,
            ),

            onPressed: () {

              Navigator.push(

                context,

                MaterialPageRoute(

                  builder: (_) =>
                  const OfflineLibraryScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: FutureBuilder<List<dynamic>>(

        future: departmentsFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final departments =
              snapshot.data ?? [];

          return ListView.builder(

            itemCount: departments.length,

            itemBuilder: (context, index) {

              final department =
              departments[index];

              return Card(
                margin: const EdgeInsets.all(10),

                child: ListTile(

                  leading:
                  const Icon(Icons.museum),

                  title: Text(
                    department["displayName"],
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            ArtworksScreen(
                              departmentId:
                              department["departmentId"],
                            ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}