import 'dart:async';
import 'dart:math'; // To generate random questions
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import Provider
import 'main.dart';
import 'splash_screen.dart';
import 'signtext.dart';
import 'voicelanguage.dart';

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
      title: 'Sign Language Quiz App',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        textTheme: TextTheme(),
        appBarTheme: AppBarTheme(
          color: themeProvider.isDarkMode ? Colors.black : Colors.white,
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
          buttonColor: themeProvider.isDarkMode ? Colors.grey : Colors.white,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SignLanguageHomePage extends StatefulWidget {
  @override
  _SignLanguageHomePageState createState() => _SignLanguageHomePageState();
}

class _SignLanguageHomePageState extends State<SignLanguageHomePage> {
  final TextEditingController _searchController = TextEditingController();

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
                  title: 'Start Quiz',
                  icon: Icons.quiz_outlined,
                  color: themeProvider.isDarkMode ? Colors.blue[800]! : Colors.grey[500]!,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QuizScreen(),
                      ),
                    );
                  },
                ),
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

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<String> _letters = List.generate(26, (index) => String.fromCharCode(65 + index));
  late List<String> _randomLetters; // Store randomized letters
  late String _currentLetter;
  int _score = 0;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  int _wrongAnswers = 0;
  List<String> _options = [];
  String? _selectedAnswer;
  bool _showFeedback = false;
  final Random _random = Random();
  final int _totalQuestions = 10; // Each quiz will have 10 questions

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
  }

  void _initializeQuiz() {
    _randomLetters = _letters..shuffle(); // Shuffle letters to randomize questions
    _randomLetters = _randomLetters.sublist(0, _totalQuestions); // Pick 10 random letters
    _loadNextQuestion();
  }

  void _loadNextQuestion() {
    setState(() {
      _currentLetter = _randomLetters[_currentQuestionIndex];
      _options = _generateOptions(_currentLetter);
      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  List<String> _generateOptions(String correctLetter) {
    List<String> options = [correctLetter];
    while (options.length < 4) {
      String randomLetter = _letters[_random.nextInt(_letters.length)];
      if (!options.contains(randomLetter)) {
        options.add(randomLetter);
      }
    }
    options.shuffle();
    return options;
  }

  void _checkAnswer(String selectedLetter) {
    setState(() {
      _selectedAnswer = selectedLetter;
      _showFeedback = true;
      if (selectedLetter == _currentLetter) {
        _correctAnswers++;
      } else {
        _wrongAnswers++;
      }
      Future.delayed(Duration(seconds: 2), () {
        if (_currentQuestionIndex < _totalQuestions - 1) {
          _currentQuestionIndex++;
          _loadNextQuestion();
        } else {
          _showQuizResults();
        }
      });
    });
  }

  void _showQuizResults() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Quiz Finished!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Results",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Correct Answers: ',
                      style: TextStyle(color: Colors.green, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$_correctAnswers',
                      style: TextStyle(color: Colors.green, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Wrong Answers: ',
                      style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '$_wrongAnswers',
                      style: TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Total Questions: $_totalQuestions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "Restart",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
              onPressed: () {
                setState(() {
                  _score = 0;
                  _currentQuestionIndex = 0;
                  _correctAnswers = 0;
                  _wrongAnswers = 0;
                  _initializeQuiz();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Language Quiz'),
        backgroundColor: Colors.blue[700],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Question ${_currentQuestionIndex + 1} of $_totalQuestions",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              "What is the meaning of this sign language?",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Image.asset('assets/$_currentLetter.png', width: 300, height: 300),
            SizedBox(height: 20),
            Column(
              children: _options.asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                String label = ['A', 'B', 'C', 'D'][index];

                Color backgroundColor = Colors.transparent;
                Color textColor = Colors.black;
                IconData? icon;

                if (_showFeedback) {
                  if (option == _currentLetter) {
                    backgroundColor = Colors.green[100]!;
                    textColor = Colors.green;
                    icon = Icons.check_circle_outline;
                  } else if (_selectedAnswer == option) {
                    backgroundColor = Colors.red[100]!;
                    textColor = Colors.red;
                    icon = Icons.cancel_outlined;
                  } else {
                    backgroundColor = Colors.grey[300]!;
                  }
                }

                return Card(
                  color: backgroundColor,
                  child: ListTile(
                    leading: icon != null ? Icon(icon, color: textColor) : null,
                    title: Text(
                      "$label. $option",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onTap: _showFeedback ? null : () => _checkAnswer(option),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
