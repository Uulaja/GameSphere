import 'package:flutter/material.dart';
import 'package:uasmobile/pages/detail_page.dart';
import '../services/api_service.dart';
import '../models/game.dart';

class GamesByGenrePage extends StatefulWidget {
  final String genreId;
  final String genreName;

  const GamesByGenrePage({required this.genreId, required this.genreName});

  @override
  _GamesByGenrePageState createState() => _GamesByGenrePageState();
}

class _GamesByGenrePageState extends State<GamesByGenrePage> {
  List<Game> games = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGames();
  }

  void fetchGames() async {
    try {
      final gamesList =
          await ApiService.fetchGamesByGenre(int.parse(widget.genreId));
      setState(() {
        games = gamesList.map((game) => Game.fromJson(game)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching games: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.genreName,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF161B22),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      backgroundColor: Color(0xFF161B22),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Color(0xFF00D1FF)),
            )
          : ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                final game = games[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Color(0xFF161B22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        game.backgroundImage,
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
                      game.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Rating: ${game.rating}',
                      style: TextStyle(color: Colors.grey.shade400),
                    ),
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey.shade400,
                      size: 16,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            id: game.id,
                            title: game.name,
                            description: 'Description for ${game.name}',
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
