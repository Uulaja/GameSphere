import 'package:flutter/material.dart';
import 'package:uasmobile/services/api_service.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final String description;
  final int id;

  DetailPage({required this.title, required this.description, required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? gameDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchGameDetail();
  }

  Future<void> fetchGameDetail() async {
    try {
      final detail = await ApiService.fetchGameDetail(widget.id);
      setState(() {
        gameDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching game detail: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212), // Hitam modern untuk background
      appBar: AppBar(
        backgroundColor: Color(0xFF1F1F1F),
        title: Text(
          widget.title,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 2,
        iconTheme: IconThemeData(color: Colors.white), // Tombol back warna putih
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(color: Color(0xFF00D1FF)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Background image
                    if (gameDetail?['background_image'] != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          gameDetail!['background_image'],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        ),
                      )
                    else
                      Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.white70,
                            size: 50,
                          ),
                        ),
                      ),
                    SizedBox(height: 20),

                    // Game name
                    Text(
                      gameDetail?['name'] ?? 'Unknown Name',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),

                    // Game description
                    Text(
                      gameDetail?['description_raw'] ?? 'No description available',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade300,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20),

                    // Additional information
                    if (gameDetail != null) ...[
                      Divider(color: Colors.grey.shade700),
                      Text(
                        'Additional Information:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow, size: 20),
                          SizedBox(width: 5),
                          Text(
                            '${gameDetail?['rating'] ?? 'N/A'} / 5',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.white70, size: 20),
                          SizedBox(width: 5),
                          Text(
                            gameDetail?['released'] ?? 'Unknown Release Date',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
