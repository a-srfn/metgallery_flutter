import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/artwork.dart';
class MetApiService {

  static const String baseUrl =
      "https://collectionapi.metmuseum.org/public/collection/v1";
  static Future<List<dynamic>>
  fetchDepartments() async {

    final response = await http.get(
      Uri.parse("$baseUrl/departments"),
    );

    if(response.statusCode == 200){

      final data =
      jsonDecode(response.body);

      return data["departments"];
    }

    throw Exception(
        "Błąd pobierania działów"
    );
  }
  static Future<List<int>>
  fetchObjectIds(
      int departmentId) async {

    final response = await http.get(
      Uri.parse(
          "$baseUrl/search?departmentId=$departmentId&q=art"
      ),
    );

    if(response.statusCode == 200){

      final data =
      jsonDecode(response.body);

      return
        List<int>.from(
            data["objectIDs"] ?? []
        );
    }

    throw Exception("Błąd");
  }
  static Future<dynamic>
  fetchArtwork(int id) async {

    final response = await http.get(
      Uri.parse(
          "$baseUrl/objects/$id"
      ),
    );

    if(response.statusCode == 200){

      return jsonDecode(
          response.body
      );
    }

    throw Exception("Błąd");
  }
  static Future<List<Artwork>>
  fetchArtworkPreview(
      int departmentId) async {

    final ids =
    await fetchObjectIds(
        departmentId);

    List<Artwork> artworks = [];

    final limit =
    ids.length > 20
        ? 20
        : ids.length;

    for (int i = 0; i < limit; i++) {

      final json =
      await fetchArtwork(ids[i]);

      artworks.add(
        Artwork.fromJson(json),
      );
    }

    return artworks;
  }
}
