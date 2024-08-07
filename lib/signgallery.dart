import 'package:flutter/material.dart';

class SignGallery extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Gallery'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3, // 3 columns
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
          ),
          itemCount: 26,
          itemBuilder: (context, index) {
            String letter = String.fromCharCode(65 + index); // A is 65 in ASCII
            String imagePath = 'assets/$letter.png';
            return GridTile(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context, index);
                },
                child: Image.asset(imagePath, fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}
