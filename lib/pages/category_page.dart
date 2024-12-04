import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uasmobile/pages/GamesByGenrePage.dart';
import 'package:uasmobile/services/api_service.dart';
import 'detail_page.dart';
import '../models/Genre.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<dynamic> games = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGenres();
  }

  void fetchGenres() async {
    try {
      final genresList = await ApiService.fetchGenres();
      setState(() {
        games = genresList;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching genres: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Color(0xFF161B22),
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Daftar Genre', style: TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: Color(0xFF00D1FF)))
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final Genre game = games[index];
                return Card(
                  color: Color(0xFF161B22),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  elevation: 5,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        game.imageBackground,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image_not_supported,
                              color: Colors.grey);
                        },
                      ),
                    ),
                    title: Text(
                      game.name, // Gunakan game.name, bukan game['name']
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing:
                        Icon(Icons.arrow_forward_ios, color: Color(0xFF00D1FF)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GamesByGenrePage(
                            genreId: game.id.toString(),
                            genreName: game.name,
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
