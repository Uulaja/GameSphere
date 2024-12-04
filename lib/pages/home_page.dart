import 'package:flutter/material.dart';
import 'package:uasmobile/pages/category_page.dart';
import '../services/api_service.dart';
import 'detail_page.dart'; // Halaman untuk detail game

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List games = [];

  @override
  void initState() {
    super.initState();
    fetchPromotedGames();
  }

  void fetchPromotedGames() async {
    try {
      final data = await ApiService.fetchPromotedGames();
      setState(() {
        games = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Color(0xFF161B22),
        elevation: 4.0,
        title: Text(
          'GameSphere',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.black.withOpacity(0.5),
                offset: Offset(0, 4),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: games.isNotEmpty
          ? ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: games.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[850], // Dark background for each box
                  ),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          games[index]['background_image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200, // Set fixed height for the image
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              games[index]['name'],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to game detail page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(
                                        id: games[index]['id'],
                                        title: games[index]['name'],
                                        description:
                                            'Description for ${games[index]['name']}'),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF00D1FF),
                              ),
                              child: Text('See Details'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(
                color: Color(0xFF00D1FF),
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF161B22),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.white),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category, color: Colors.white),
            label: 'Genre',
          ),
        ],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoryPage()),
            );
          }
        },
      ),
    );
  }
}
