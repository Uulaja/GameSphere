import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Genre.dart';

class ApiService {
  static const String _baseUrl = "https://api.rawg.io/api";
  static const String _apiKey = "14265a29fca24959b6696af78f2a6335"; 

  // Fetch genres
  static Future<List<Genre>> fetchGenres() async {
    final response = await http.get(Uri.parse("$_baseUrl/genres?key=$_apiKey"));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((genre) => Genre.fromJson(genre))
          .toList();
    } else {
      throw Exception("Failed to load genres");
    }
  }

  // Fetch games by genre
  static Future<List<dynamic>> fetchGamesByGenre(int genreId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/games?key=$_apiKey&genres=$genreId"),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['results'];
    } else {
      throw Exception("Failed to load games");
    }
  }
   // Fetch game detail by ID
  static Future<Map<String, dynamic>> fetchGameDetail(int gameId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/games/$gameId?key=$_apiKey"),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to load game detail");
    }
  }
  // Fetch promoted games
static Future<List<dynamic>> fetchPromotedGames() async {
  final response = await http.get(
    Uri.parse("$_baseUrl/games?key=$_apiKey&ordering=-popularity&page_size=10")

  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['results'];
  } else {
    throw Exception("Failed to load promoted games");
  }
}

}
