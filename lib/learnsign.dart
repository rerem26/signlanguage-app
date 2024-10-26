import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: SignLanguageApp(),
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
      home: SignLanguageHomePage(),
    );
  }
}

class SignLanguageHomePage extends StatefulWidget {
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
                builder: (context) => QuizScreen(),
              ),
            );
          },
          child: Text('Start Quiz'),
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
  List<Map<String, dynamic>> _textQuestions = [
    {
      'question': 'The social beliefs, traditions, art, history, and recreation that occurs among people who are brought together by sign language and influenced by deafness.',
      'options': ['Deaf Culture', 'Deaf Community', 'Deaf Association', 'Deafhood'],
      'answer': 'Deaf Culture'
    },
    {
      'question': 'The letters of the English alphabet represented by hand signs, as used in ASL.',
      'options': ['Fingerspelling', 'American Sign Language', 'American Manual Alphabet', 'Deaf Culture'],
      'answer': 'American Manual Alphabet'
    },
    {
      'question': 'A system of communication using visual gestures and signs.',
      'options': ['Fingerspelling', 'Home Sign', 'Sign Language', 'Facial Expression'],
      'answer': 'Sign Language'
    },
    {
      'question': 'An action that conveys meaning.',
      'options': ['Sign', 'Symptom', 'Oralism', 'Martha\'s Vineyard Sign Language'],
      'answer': 'Sign'
    },
    {
      'question': 'Method of teaching the Deaf by learning to understand and produce spoken language.',
      'options': ['Sign Language', 'Oralism', 'Manualism', 'Audism'],
      'answer': 'Oralism'
    },
    {
      'question': 'A form of communication developed by a Deaf person who has no access to learning a sign language.',
      'options': ['Home Sign', 'Martha\'s Vineyard Sign Language', 'Critical Period', 'Sign Language'],
      'answer': 'Home Sign'
    },
    {
      'question': 'A village sign language practiced in a small community on Martha\'s Vineyard Island where a hereditary form of deafness was common.',
      'options': ['Sign', 'Home Sign Languages', 'Old French Sign Language', 'Martha\'s Vineyard Sign Language'],
      'answer': 'Martha\'s Vineyard Sign Language'
    },
    {
      'question': 'Using letter signs to spell out a word in sign language.',
      'options': ['American Manual Alphabet', 'Fingerspelling', 'Manualism', 'Martha\'s Vineyard Sign Language'],
      'answer': 'Fingerspelling'
    },
    {
      'question': 'The use of sign language to educate the Deaf.',
      'options': ['Oralism', 'American Manual Alphabet', 'Fingerspelling', 'Manualism'],
      'answer': 'Manualism'
    },
    {
      'question': 'A visual language used by Deaf people in the United States and parts of Canada that uses hand shape, movement, and facial expression to convey meaning.',
      'options': ['American Sign Language (ASL)', 'Latin', 'Interpretive', 'Electric larynx'],
      'answer': 'American Sign Language (ASL)'
    },
    {
      'question': 'What is the sign language for "HELLO"?',
      'options': ['Wave hand near forehead', 'Point to the ground', 'Cross arms', 'Make a fist'],
      'answer': 'Wave hand near forehead',
      'image': 'assets/hello.png'
    },
    {
      'question': 'What is the sign language for "GOODBYE"?',
      'options': ['Wave hand', 'Thumbs up', 'Point to mouth', 'Cross fingers'],
      'answer': 'Wave hand',
      'image': 'assets/goodbye.png'
    },
    {
      'question': 'What is the sign language for "PLEASE"?',
      'options': ['Move hand in a circular motion on chest', 'Point to the sky', 'Clap hands', 'Tap your nose'],
      'answer': 'Move hand in a circular motion on chest',
      'image': 'assets/please.png'
    },
    {
      'question': 'What is the sign language for "NO"?',
      'options': ['Tap index and middle finger together', 'Shake head', 'Thumbs down', 'Wave both hands'],
      'answer': 'Tap index and middle finger together',
      'image': 'assets/no.png'
    },
    {
      'question': 'What is the sign language for "YES"?',
      'options': ['Make a fist and nod', 'Wave hand', 'Tap shoulder', 'Cross arms'],
      'answer': 'Make a fist and nod',
      'image': 'assets/yes.png'
    },
    {
      'question': 'What is the sign language for "THANK YOU"?',
      'options': ['Move hand outward from chin', 'Thumbs up', 'Cross fingers', 'Wave hand'],
      'answer': 'Move hand outward from chin',
      'image': 'assets/thankyou.png'
    },
    {
      "question": "A manual alphabet used by deaf individuals to spell out words in English, where each handshape represents a letter.",
      "options": ["Finger Spelling", "Braille", "Closed Captioning", "Interpretive Signing"],
      "answer": "Finger Spelling"
    },
    {
      "question": "The Filipino Sign Language (FSL) is the primary language used by the Deaf community in which country?",
      "options": ["Philippines", "Thailand", "United States", "Japan"],
      "answer": "Philippines"
    },
    {
      "question": "What term describes the use of both speech and sign language simultaneously?",
      "options": ["Total Communication", "Manualism", "Cued Speech", "Auditory-Oral Method"],
      "answer": "Total Communication"
    },
    {
      "question": "Which of these elements is NOT a key feature of sign language?",
      "options": ["Handshape", "Tone of voice", "Movement", "Facial expression"],
      "answer": "Tone of voice"
    },
    {
      "question": "Which hand orientation, movement, and space technique is commonly used to distinguish meaning in sign language?",
      "options": ["Morphology", "Iconicity", "Grammar", "Spatial Referencing"],
      "answer": "Spatial Referencing"
    },
    {
      "question": "What is the term for using hands to represent specific words, letters, or phrases in sign language?",
      "options": ["Signing", "Oralism", "Articulation", "Dactylology"],
      "answer": "Signing"
    },
    {
      "question": "Which form of communication involves a combination of lip-reading, speech, and natural gestures?",
      "options": ["Oralism", "Cued Speech", "Manualism", "Total Communication"],
      "answer": "Oralism"
    },
    {
      "question": "Which handshape is used to represent the letter 'A' in the American Sign Language alphabet?",
      "options": ["Closed fist with thumb out", "Open hand", "V-shape", "Thumb between index and middle fingers"],
      "answer": "Closed fist with thumb out"
    },
    {
      "question": "What is the primary reason facial expressions are important in sign language?",
      "options": ["To indicate emotional tone", "To replace spoken words", "To indicate the beginning of a sentence", "For fashion"],
      "answer": "To indicate emotional tone"
    },
    {
      "question": "In sign language, what is the purpose of spatial referencing?",
      "options": ["To represent past or future events", "To increase speed of signing", "To emphasize nouns", "To indicate locations or persons"],
      "answer": "To indicate locations or persons"
    },
    {
      "question": "What is a classifier in sign language?",
      "options": ["A handshape used to represent a specific object", "An alphabet letter", "A technique for louder signing", "A system for teaching sign language"],
      "answer": "A handshape used to represent a specific object"
    },
    {
      "question": "Which of these refers to the movement of hands to form specific signs in sign language?",
      "options": ["Signing", "Typing", "Voicing", "Acting"],
      "answer": "Signing"
    },
    {
      "question": "What does the non-dominant hand usually do in two-handed signs?",
      "options": ["Supports the dominant hand", "Stays idle", "Moves freely", "Indicates tense"],
      "answer": "Supports the dominant hand"
    },
    {
      "question": "Which language is considered the first visual language that includes its own grammar and syntax, used by Deaf communities?",
      "options": ["American Sign Language (ASL)", "Written English", "Cued Speech", "Morse Code"],
      "answer": "American Sign Language (ASL)"
    },
    {
      "question": "What aspect of sign language allows for the expression of abstract concepts and ideas?",
      "options": ["Iconicity", "Spatial Referencing", "Grammar", "Symbolic Representation"],
      "answer": "Symbolic Representation"
    },
    {
      "question": "What is the name of the system that helps Deaf individuals learn to read lips and understand speech sounds?",
      "options": ["Cued Speech", "Braille", "Finger Spelling", "Oralism"],
      "answer": "Cued Speech"
    }
  ];


  late List<Map<String, dynamic>> _questions;
  int _currentQuestionIndex = 0;
  int _correctAnswers = 0;
  String? _selectedAnswer;
  bool _showFeedback = false;
  final Random _random = Random();
  final int _totalQuestions = 10;
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
        'question': 'What is the meaning of this sign language?',
        'image': 'assets/$letter.png',
        'options': _generateOptions(letter),
        'answer': letter
      };
    }).toList();

    _questions = [...letterImageQuestions, ..._textQuestions]..shuffle();
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

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
      Future.delayed(Duration(seconds: 1), () {
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
    int completion = ((_currentQuestionIndex + 1) / _totalQuestions * 100).round();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents closing when tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: EdgeInsets.all(16.0),
          title: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.blue,
                child: Text(
                  "${_correctAnswers * 10} pt",
                  style: TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Your Score",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 28),
                      SizedBox(height: 4),
                      Text(
                        "$_correctAnswers Correct",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Icon(Icons.cancel, color: Colors.red, size: 28),
                      SizedBox(height: 4),
                      Text(
                        "$totalWrong Wrong",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                "Completion: $completion%",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.blueGrey),
              ),
              SizedBox(height: 20),
              Divider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.refresh, color: Colors.blue, size: 32),
                    onPressed: () {
                      setState(() {
                        _initializeQuiz();
                        _startTimer();
                      });
                      Navigator.of(context).pop(); // Closes the dialog
                    },
                    tooltip: "Play Again",
                  ),
                  IconButton(
                    icon: Icon(Icons.home, color: Colors.purple, size: 32),
                    onPressed: () {
                      Navigator.of(context).pop(); // Closes the dialog
                      Navigator.of(context).pop(); // Goes back to home
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
        title: Text('Sign Language Quiz'),
        backgroundColor: Colors.blue[700],
        actions: [
          Container(
            padding: EdgeInsets.all(8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: _timeLeft / 30,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                Text(
                  "$_timeLeft",
                  style: TextStyle(
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
            SizedBox(height: 20),
            Text(
              "Question ${_currentQuestionIndex + 1} of $_totalQuestions",
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              _questions[_currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            if (isImageQuestion)
              Image.asset(
                _questions[_currentQuestionIndex]['image'],
                width: 300,
                height: 300,
              ),
            SizedBox(height: 20),
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
