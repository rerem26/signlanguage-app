import 'package:flutter/material.dart';

class Alphabets extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Total items: 26 uppercase letters + 10 numbers (0-9) + 26 lowercase letters (a-z)
    final totalItems = 26 + 10 + 26;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn Alphabets and Numbers',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 2.0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[200]!],
          ),
        ),
        child: GridView.builder(
          padding: EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns in the grid
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1.0, // Square cells
          ),
          itemCount: totalItems,
          itemBuilder: (context, index) {
            String imagePath;
            String displayText;

            if (index < 10) {
              // First 10 items are numbers (0-9)
              imagePath = 'assets/letters/${index}.png';
              displayText = 'Number $index';
            } else if (index >= 10 && index < 36) {
              // Next 26 items are uppercase letters (A-Z)
              String letter = String.fromCharCode(65 + (index - 10)); // ASCII for A-Z
              imagePath = 'assets/$letter.png';
              displayText = 'Letter $letter';
            } else {
              // Remaining items are lowercase letters (a-z)
              String lowercaseLetter = String.fromCharCode(97 + (index - 36)); // ASCII for a-z
              imagePath = 'assets/letters/$lowercaseLetter.png';
              displayText = 'Letter $lowercaseLetter';
            }

            return GestureDetector(
              onTap: () {
                // Navigate to the detail screen with the image path and description
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AlphabetDetailScreen(
                      imagePath: imagePath,
                      description: displayText,
                    ),
                  ),
                );
              },
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text(
                                'Image not found',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        displayText,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class AlphabetDetailScreen extends StatelessWidget {
  final String imagePath;
  final String description;

  AlphabetDetailScreen({required this.imagePath, required this.description});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          description,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[200]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Image not found\n$imagePath',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'This section provides information and a visual representation for $description.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
