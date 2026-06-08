import 'package:flutter/material.dart';
import '../services/met_api_service.dart';
import 'artwork_details_screen.dart';

class ArtworksScreen extends StatefulWidget {
  final int departmentId;

  const ArtworksScreen({
    super.key,
    required this.departmentId,
  });

  @override
  State<ArtworksScreen> createState() =>
      _ArtworksScreenState();
}

class _ArtworksScreenState
    extends State<ArtworksScreen> {

  late Future<List<int>> artworksFuture;

  @override
  void initState() {
    super.initState();

    artworksFuture =
        MetApiService.fetchObjectIds(
          widget.departmentId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Artworks"),
      ),

      body: FutureBuilder<List<int>>(

        future: artworksFuture,

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

          final objectIds =
              snapshot.data ?? [];

          if (objectIds.isEmpty) {
            return const Center(
              child: Text(
                "No artworks found",
              ),
            );
          }

          return ListView.builder(

            itemCount: objectIds.length > 20
                ? 20
                : objectIds.length,

            itemBuilder: (context, index) {

              final objectId =
              objectIds[index];

              return Card(
                margin:
                const EdgeInsets.all(8),

                child: ListTile(

                  title: Text(
                    "Artwork $objectId",
                  ),

                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                  ),

                  onTap: () {

                    Navigator.push(

                      context,

                      MaterialPageRoute(
                        builder: (_) =>
                            ArtworkDetailsScreen(
                              objectId: objectId,
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