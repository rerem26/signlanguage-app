import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'alphabets.dart';
import 'splash_screen.dart';
import 'signtext.dart';
import 'learnsign.dart';
import 'voicelanguage.dart';
import 'practice_asl.dart';
import 'feedback_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: SignLanguageApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
}

class SignLanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sign Language App',
      theme: ThemeData(
        brightness: Brightness.light, // Always use light mode
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.transparent, // Make AppBar transparent
          elevation: 0, // Remove elevation
          iconTheme: IconThemeData(
            color: Colors.black, // Set icon color to black for light mode
          ),
          titleTextStyle: TextStyle(
            color: Colors.black, // Set title color to black for light mode
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(), // Start with your splash screen
    );
  }
}

class SignLanguageHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Language App',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.blue[100]!], // Light blue gradient
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 40), // Adjusted spacing
                SignLanguageBox(
                  title: 'Practice Sign Language',
                  icon: Icons.video_collection_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PracticeASL()),
                    );
                  },
                ),
                SizedBox(height: 20),
                SignLanguageBox(
                  title: 'Learn Alphabets',
                  icon: Icons.menu_book_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Alphabets()),
                    );
                  },
                ),
                SizedBox(height: 20),
                SignLanguageBox(
                  title: 'Quiz',
                  icon: Icons.quiz_rounded,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => QuizScreen()),
                    );
                  },
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SignLanguageBox(
                        title: 'Sign to Text',
                        icon: Icons.camera_alt_outlined,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignText()),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SignLanguageBox(
                        title: 'Voice to Sign',
                        icon: Icons.mic_none_outlined,
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
                SizedBox(height: 20),
                SignLanguageBox(
                  title: 'Feedback',
                  icon: Icons.feedback_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => FeedbackScreen()),
                    );
                  },
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.blue[100], // Light color for background
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Powered by Intellitech Solutions',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class SignLanguageBox extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  SignLanguageBox({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2), // Blue border
        borderRadius: BorderRadius.circular(15),
        color: Colors.transparent, // Transparent background
      ),
      child: Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(15),
        shadowColor: Colors.black45,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.transparent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 36,
                  color: Colors.blue,
                ),
                SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
