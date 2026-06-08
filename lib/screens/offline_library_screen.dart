import 'package:flutter/material.dart';

import '../models/artwork.dart';
import '../services/artwork_local_database.dart';
import 'artwork_details_screen.dart';

class OfflineLibraryScreen extends StatefulWidget {
  const OfflineLibraryScreen({super.key});

  @override
  State<OfflineLibraryScreen> createState() =>
      _OfflineLibraryScreenState();
}

class _OfflineLibraryScreenState
    extends State<OfflineLibraryScreen> {

  late List<Artwork> artworks;

  @override
  void initState() {
    super.initState();

    artworks =
        ArtworkLocalDatabase.getArtworks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Offline Library",
        ),
      ),

      body: artworks.isEmpty

          ? const Center(
        child: Text(
          "No saved artworks",
        ),
      )

          : ListView.builder(

        itemCount: artworks.length,

        itemBuilder: (context, index) {

          final artwork =
          artworks[index];

          return Card(

            margin:
            const EdgeInsets.all(8),

            child: ListTile(

              leading:

              artwork.imageUrl.isNotEmpty

                  ? Image.network(
                artwork.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )

                  : const Icon(
                Icons.image_not_supported,
              ),

              title: Text(
                artwork.title,
              ),

              subtitle: Text(
                artwork.artist.isEmpty
                    ? "Unknown artist"
                    : artwork.artist,
              ),

              trailing: IconButton(

                icon:
                const Icon(Icons.delete),

                onPressed: () async {

                  await ArtworkLocalDatabase
                      .deleteArtwork(
                      artwork.id);

                  setState(() {

                    artworks =
                        ArtworkLocalDatabase
                            .getArtworks();
                  });
                },
              ),

              onTap: () {

                Navigator.push(

                  context,

                  MaterialPageRoute(

                    builder: (_) =>
                        ArtworkDetailsScreen(
                          objectId:
                          artwork.id,
                        ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}