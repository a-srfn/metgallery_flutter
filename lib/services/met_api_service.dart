import 'dart:convert';
import 'package:http/http.dart' as http;

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
}
