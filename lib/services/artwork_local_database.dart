import 'package:hive_ce/hive.dart';
import '../models/artwork.dart';
import 'dart:developer';

class ArtworkLocalDatabase {

  static Box get _box =>
      Hive.box("saved_artworks");

  static List<Artwork> getArtworks() {

    return _box.values.map((item) {

      return Artwork.fromMap(
        Map<String, dynamic>.from(item),
      );

    }).toList();
  }

  static Future<void> saveArtwork(
      Artwork artwork) async {

    log(
      "Zapisywanie dzieła: ${artwork.title}",
      name: "ArtworkLocalDatabase",
    );

    await _box.put(
      artwork.id,
      artwork.toMap(),
    );
  }

  static Future<void> deleteArtwork(
      int id) async {

    log(
      "Usuwanie dzieła o id: $id",
      name: "ArtworkLocalDatabase",
    );

    await _box.delete(id);
  }

  static bool isEmpty() {

    return _box.isEmpty;
  }
}