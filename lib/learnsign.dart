import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const SignLanguageApp(),
    ),
  );
}

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Sign Language Quiz App',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      debugShowCheckedModeBanner: false,
      home: const SignLanguageHomePage(),
    );
  }
}

class SignLanguageHomePage extends StatefulWidget {
  const SignLanguageHomePage({super.key});

  @override
  _SignLanguageHomePageState createState() => _SignLanguageHomePageState();
}

class _SignLanguageHomePageState extends State<SignLanguageHomePage> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign Language App',
          style: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
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
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const QuizScreen(),
              ),
            );
          },
          child: const Text('Start Quiz'),
        ),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<String> _letters = List.generate(26, (index) => String.fromCharCode(65 + index));
  final List<Map<String, dynamic>> _textQuestions = [
    {
      "question": "The social beliefs, traditions, art, history, and recreation that occurs among people who are brought together by sign language and influenced by deafness.",
      "options": ["Deafhood", "Deaf Community", "Deaf Culture", "Deaf Association"],
      "answer": "Deaf Culture"
    },
    {
      "question": "The letters of the English alphabet represented by hand signs, as used in ASL.",
      "options": ["American Sign Language", "Deaf Culture", "Fingerspelling", "American Manual Alphabet"],
      "answer": "American Manual Alphabet"
    },
    {
      "question": "A system of communication using visual gestures and signs.",
      "options": ["Sign Language", "Home Sign", "Fingerspelling", "Facial Expression"],
      "answer": "Sign Language"
    },
    {
      "question": "An action that conveys meaning.",
      "options": ["Symptom", "Oralism", "Sign", "Martha's Vineyard Sign Language"],
      "answer": "Sign"
    },
    {
      "question": "Method of teaching the Deaf by learning to understand and produce spoken language.",
      "options": ["Audism", "Manualism", "Oralism", "Sign Language"],
      "answer": "Oralism"
    },
    {
      "question": "A form of communication developed by a Deaf person who has no access to learning a sign language.",
      "options": ["Martha's Vineyard Sign Language", "Critical Period", "Home Sign", "Sign Language"],
      "answer": "Home Sign"
    },
    {
      "question": "A village sign language practiced in a small community on Martha's Vineyard Island where a hereditary form of deafness was common.",
      "options": ["Home Sign Languages", "Martha's Vineyard Sign Language", "Old French Sign Language", "Sign"],
      "answer": "Martha's Vineyard Sign Language"
    },
    {
      "question": "Using letter signs to spell out a word in sign language.",
      "options": ["Manualism", "American Manual Alphabet", "Fingerspelling", "Martha's Vineyard Sign Language"],
      "answer": "Fingerspelling"
    },
    {
      "question": "The use of sign language to educate the Deaf.",
      "options": ["Fingerspelling", "Oralism", "Manualism", "American Manual Alphabet"],
      "answer": "Manualism"
    },
    {
      "question": "A visual language used by Deaf people in the United States and parts of Canada that uses hand shape, movement, and facial expression to convey meaning.",
      "options": ["Interpretive", "Electric larynx", "Latin", "American Sign Language (ASL)"],
      "answer": "American Sign Language (ASL)"
    },
  ];

  // New questions from Basics and Intermediates
  final List<Map<String, dynamic>> _basicsAndIntermediatesQuestions = [
    {
      "question": "What is the sign language for 'HELLO'?",
      "options": ["Wave hand near forehead", "Point to chin", "Raise both hands", "Shake hand"],
      "answer": "Wave hand near forehead",
      "image": "assets/Hello.png"
    },
    {
      "question": "What is the sign language for 'PLEASE'?",
      "options": ["Tap chin", "Circular motion on chest", "Wave hand", "Point up"],
      "answer": "Circular motion on chest",
      "image": "assets/please.png"
    },
    {
      "question": "What is the sign language for 'GOOD MORNING'?",
      "options": ["Palm on chin, move down", "Open hand gesture", "Wave", "Point to the sky"],
      "answer": "Palm on chin, move down",
      "image": "assets/GoodMorning.png"
    },
    {
      "question": "What is the sign language for 'GOOD NIGHT'?",
      "options": ["Palm to forehead", "Move hand down", "Close hands", "Wave"],
      "answer": "Palm to forehead",
      "image": "assets/GoodNight.png"
    },
    {
      "question": "What is the sign language for 'YES'?",
      "options": ["Nod head", "Fist with thumb up", "Shake hand", "Open palm"],
      "answer": "Fist with thumb up",
      "image": "assets/yes.png"
    },
    {
      "question": "What is the sign language for 'NO'?",
      "options": ["Shake head", "Point to ground", "Tap fingers together", "Fist with thumb down"],
      "answer": "Tap fingers together",
      "image": "assets/no.png"
    },
    {
      "question": "What is the sign language for 'THANK YOU'?",
      "options": ["Move hand outward from chin", "Shake hands", "Raise hand", "Open palm"],
      "answer": "Move hand outward from chin",
      "image": "assets/thankyou.png"
    },
    {
      "question": "What is the sign language for 'GOOD AFTERNOON'?",
      "options": ["Palm on chin, move to left", "Open hand in front", "Raise both hands", "Wave"],
      "answer": "Palm on chin, move to left",
      "image": "assets/GoodAfternoon.png"
    },
    {
      "question": "What is the sign language for 'HI'?",
      "options": ["Wave", "Raise hand", "Point", "Fist"],
      "answer": "Wave",
      "image": "assets/Hi.png"
    },
    {
      "question": "What is the sign language for 'GOOD NOON'?",
      "options": ["Palm on chin, drop hand", "Wave hand", "Point to the sky", "Close fist"],
      "answer": "Palm on chin, drop hand",
      "image": "assets/GoodNoon.png"
    },
  ];

  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _selectedAnswer;
  bool _showFeedback = false;
  final Random _random = Random();
  final int _totalQuestions = 10; // Number of total questions
  Timer? _timer;
  int _timeLeft = 30;

  @override
  void initState() {
    super.initState();
    _initializeQuiz();
    _startTimer();
  }

  void _initializeQuiz() {
    List<Map<String, dynamic>> letterImageQuestions = _letters.map((letter) {
      return {
        'question': 'What is the meaning of this sign language for?',
        'image': 'assets/$letter.png',
        'options': _generateOptions(letter),
        'answer': letter
      };
    }).toList();

    // Combine all questions and shuffle
    _questions = [...letterImageQuestions, ..._textQuestions, ..._basicsAndIntermediatesQuestions]..shuffle();
    _questions = _questions.sublist(0, _totalQuestions);
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    _showFeedback = false;
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

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 30;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _showQuizResults();
        }
      });
    });
  }

  void _checkAnswer(String? selectedAnswer) {
    setState(() {
      _selectedAnswer = selectedAnswer;
      _showFeedback = true;
      if (selectedAnswer == _questions[_currentQuestionIndex]['answer']) {
        _correctAnswers++;
      }
      Future.delayed(const Duration(seconds: 1), () {
        if (_currentQuestionIndex < _totalQuestions - 1) {
          setState(() {
            _currentQuestionIndex++;
            _showFeedback = false;
            _selectedAnswer = null;
          });
        } else {
          _showQuizResults();
        }
      });
    });
  }

  void _showQuizResults() {
    int totalWrong = _totalQuestions - _correctAnswers;
    int completion = _totalQuestions > 0 ? ((_correctAnswers / _totalQuestions) * 100).round() : 0; // Calculate the completion percentage

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.all(16.0),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue,
                child: Text(
                  "${_correctAnswers * 10} pt",
                  style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Your Score",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        "$_correctAnswers Correct",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red, size: 28),
                      const SizedBox(height: 4),
                      Text(
                        "$totalWrong Wrong",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Completion: $completion%",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey),
              ),
              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.blue, size: 32),
                    onPressed: () {
                      setState(() {
                        _initializeQuiz();
                        _startTimer();
                      });
                      Navigator.of(context).pop();
                    },
                    tooltip: "Play Again",
                  ),
                  IconButton(
                    icon: const Icon(Icons.home, color: Colors.purple, size: 32),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    tooltip: "Home",
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isImageQuestion = _questions[_currentQuestionIndex].containsKey('image');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Language Quiz'),
        backgroundColor: Colors.blue[700],
        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _timeLeft / 30,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                Text(
                  "$_timeLeft",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Question ${_currentQuestionIndex + 1} of $_totalQuestions",
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (isImageQuestion)
              Image.asset(
                _questions[_currentQuestionIndex]['image'],
                width: 300,
                height: 300,
              ),
            const SizedBox(height: 20),
            Column(
              children: (_questions[_currentQuestionIndex]['options'] as List<String>).asMap().entries.map((entry) {
                int index = entry.key;
                String option = entry.value;
                String label = ['A', 'B', 'C', 'D'][index];

                Color backgroundColor = Colors.transparent;
                Color textColor = Colors.white;
                IconData? icon;

                if (_showFeedback) {
                  if (option == _questions[_currentQuestionIndex]['answer']) {
                    backgroundColor = Colors.green[100]!; // Correct answer
                    textColor = Colors.green;
                    icon = Icons.check_circle_outline;
                  } else if (_selectedAnswer == option) {
                    backgroundColor = Colors.red[100]!; // Incorrect answer
                    textColor = Colors.red;
                    icon = Icons.cancel_outlined;
                  } else {
                    backgroundColor = Colors.grey[300]!; // Not selected
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
