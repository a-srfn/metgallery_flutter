import 'package:flutter/material.dart';
import '../services/met_api_service.dart';
import 'artwork_details_screen.dart';
import '../models/artwork.dart';
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
    final TextEditingController searchController =
    TextEditingController();

  String searchText = "";
  late Future<List<Artwork>> artworksFuture;

  @override
  void initState() {
    super.initState();

    artworksFuture =
        MetApiService.fetchArtworkPreview(
          widget.departmentId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text("Artworks"),
      ),

      body: FutureBuilder<List<Artwork>>(

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

          final artworks =
              snapshot.data ?? [];
          final filteredArtworks =
          artworks.where((artwork) {

            return artwork.title
                .toLowerCase()
                .contains(searchText);

          }).toList();
          return Column(
            children: [

              Padding(
                padding: const EdgeInsets.all(8),

                child: TextField(

                  controller: searchController,

                  decoration: const InputDecoration(
                    labelText: "Search artworks",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),

                  onChanged: (value) {

                    setState(() {

                      searchText =
                          value.toLowerCase();
                    });
                  },
                ),
              ),

              Expanded(
                child: filteredArtworks.isEmpty

                    ? const Center(
                  child: Text(
                    "No artworks found",
                  ),
                )

                    : ListView.builder(

                  itemCount:
                  filteredArtworks.length,

                  itemBuilder: (context, index) {

                    final artwork =
                    filteredArtworks[index];

                    return Card(

                      margin:
                      const EdgeInsets.all(8),

                      child: ListTile(

                        title: Text(
                          artwork.title,
                        ),

                        subtitle: Text(

                          artwork.artist.isEmpty

                              ? "Unknown artist"

                              : artwork.artist,
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
              ),
            ],
          );

        },
      ),
    );
  }
}