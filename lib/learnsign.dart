import 'dart:async';
import 'package:flutter/material.dart';
import 'main.dart';
import 'splash_screen.dart';
import 'signtext.dart';
import 'learnsign.dart';
import 'voicelanguage.dart';
import 'package:provider/provider.dart'; // Import Provider

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: SignLanguageApp(),
    ),
  );
}

class SignLanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Sign Language App',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.deepPurple,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        textTheme: TextTheme(),
        appBarTheme: AppBarTheme(
          color: themeProvider.isDarkMode ? Colors.black : Colors.deepPurple,
          iconTheme: IconThemeData(
            color: themeProvider.isDarkMode ? Colors.white : Colors.white,
          ),
          titleTextStyle: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: themeProvider.isDarkMode ? Colors.grey : Colors.deepPurple,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SignLanguageHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Language App',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: themeProvider.isDarkMode
                ? [Colors.black, Colors.grey[850]!]
                : [Colors.white, Colors.grey[300]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Spacer(),
              Container(
                width: 350,
                child: SignLanguageBox(
                  title: 'Learn Signs',
                  icon: Icons.school_outlined,
                  color: themeProvider.isDarkMode ? Colors.blue[800]! : Colors.blue[300]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LearnSign(),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 165,
                    child: SignLanguageBox(
                      title: 'Sign to Text',
                      icon: Icons.camera_alt_outlined,
                      color: themeProvider.isDarkMode ? Colors.blue[800]! : Colors.blue[300]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignText()),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 165,
                    child: SignLanguageBox(
                      title: 'Voice to Sign',
                      icon: Icons.mic_none_outlined,
                      color: themeProvider.isDarkMode ? Colors.blue[800]! : Colors.blue[300]!,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Voice_To_Sign()),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Spacer(),
              Text(
                'Powered by Intellitech Solutions',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignLanguageBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  SignLanguageBox({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8.0,
      borderRadius: BorderRadius.circular(15),
      shadowColor: Colors.black45,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 36,
                color: Colors.white,
              ),
              SizedBox(height: 6),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LearnSign extends StatefulWidget {
  final int initialIndex;

  LearnSign({this.initialIndex = 0});

  @override
  _LearnSignState createState() => _LearnSignState();
}

class _LearnSignState extends State<LearnSign> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Learn Signs'),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.deepPurple,
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: themeProvider.isDarkMode
                    ? [Colors.black, Colors.grey[850]!]
                    : [Colors.white, Colors.grey[300]!],
              ),
            ),
          ),
          PageView.builder(
            controller: _pageController,
            itemCount: 26,
            itemBuilder: (context, index) {
              String letter = String.fromCharCode(65 + index); // A is 65 in ASCII
              String imagePath = 'assets/$letter.png';
              return Container(
                color: Colors.transparent,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Learn the Sign for '$letter'",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        Image.asset(imagePath, width: 300, height: 300),
                        SizedBox(height: 20),
                        Text(
                          "Swipe left or right to learn the signs for other letters.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          Positioned(
            left: 10,
            top: MediaQuery.of(context).size.height / 2 - 80,
            child: IconButton(
              icon: Icon(Icons.arrow_left, size: 50, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
          Positioned(
            right: 10,
            top: MediaQuery.of(context).size.height / 2 - 80,
            child: IconButton(
              icon: Icon(Icons.arrow_right, size: 50, color: themeProvider.isDarkMode ? Colors.white : Colors.black),
              onPressed: () {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
