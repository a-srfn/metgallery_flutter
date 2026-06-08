import 'package:flutter/material.dart';
import '../services/met_api_service.dart';
import '../models/artwork.dart';
import '../services/artwork_local_database.dart';
class ArtworkDetailsScreen
    extends StatefulWidget {

  final int objectId;

  const ArtworkDetailsScreen({
    super.key,
    required this.objectId,
  });

  @override
  State<ArtworkDetailsScreen> createState() =>
      _ArtworkDetailsScreenState();
}

class _ArtworkDetailsScreenState
    extends State<ArtworkDetailsScreen> {

  late Future<dynamic> artworkFuture;

  @override
  void initState() {
    super.initState();

    artworkFuture =
        MetApiService.fetchArtwork(
          widget.objectId,
        );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Artwork Details",
        ),
      ),

      body: FutureBuilder<dynamic>(

        future: artworkFuture,

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {

            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final artwork =
              snapshot.data;

          return SingleChildScrollView(

            padding:
            const EdgeInsets.all(16),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                if (artwork["primaryImageSmall"] !=
                    null &&
                    artwork["primaryImageSmall"] !=
                        "")

                  Image.network(
                    artwork["primaryImageSmall"],
                  ),

                const SizedBox(height: 20),

                Text(
                  artwork["title"] ??
                      "No title",
                  style:
                  const TextStyle(
                    fontSize: 24,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  "Artist: ${artwork["artistDisplayName"] ?? "Unknown"}",
                ),

                const SizedBox(height: 10),

                Text(
                  "Culture: ${artwork["culture"] ?? "Unknown"}",
                ),

                const SizedBox(height: 10),

                Text(
                  "Date: ${artwork["objectDate"] ?? "Unknown"}",
                ),
                ElevatedButton(
                  onPressed: () {

                    final savedArtwork = Artwork.fromJson(
                      artwork,
                    );

                    ArtworkLocalDatabase.saveArtwork(
                      savedArtwork,
                    );
                  },

                  child: const Text(
                    "Save to Offline Library",
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}