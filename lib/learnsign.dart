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

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  _QuizScreenState createState() => _QuizScreenState();
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

class _QuizScreenState extends State<QuizScreen> {
  final List<String> _letters = List.generate(26, (index) => String.fromCharCode(65 + index));
  final List<Map<String, dynamic>> _questionsData = [
    {
      "question": "A manual alphabet used by deaf individuals to spell out words in English, where each handshape represents a letter.",
      "options": ["Interpretive Signing", "Finger Spelling", "Braille", "Closed Captioning"],
      "answer": "Finger Spelling"
    },
    {
      "question": "The Filipino Sign Language (FSL) is the primary language used by the Deaf community in which country?",
      "options": ["Philippines", "Japan", "United States", "Thailand"],
      "answer": "Philippines"
    },
    {
      "question": "What term describes the use of both speech and sign language simultaneously?",
      "options": ["Total Communication", "Manualism", "Cued Speech", "Auditory-Oral Method"],
      "answer": "Total Communication"
    },
    {
      "question": "Which of these elements is NOT a key feature of sign language?",
      "options": ["Handshape", "Facial expression", "Tone of voice", "Movement"],
      "answer": "Tone of voice"
    },
    {
      "question": "Which hand orientation, movement, and space technique is commonly used to distinguish meaning in sign language?",
      "options": ["Spatial Referencing", "Iconicity", "Morphology", "Grammar"],
      "answer": "Spatial Referencing"
    },
    {
      "question": "What is the term for using hands to represent specific words, letters, or phrases in sign language?",
      "options": ["Dactylology", "Signing", "Oralism", "Articulation"],
      "answer": "Signing"
    },
    {
      "question": "Which form of communication involves a combination of lip-reading, speech, and natural gestures?",
      "options": ["Manualism", "Oralism", "Cued Speech", "Total Communication"],
      "answer": "Oralism"
    },
    {
      "question": "Which handshape is used to represent the letter 'A' in the American Sign Language alphabet?",
      "options": ["V-shape", "Thumb between index and middle fingers", "Closed fist with thumb out", "Open hand"],
      "answer": "Closed fist with thumb out"
    },
    {
      "question": "What is the primary reason facial expressions are important in sign language?",
      "options": ["To indicate the beginning of a sentence", "To indicate emotional tone", "To replace spoken words", "For fashion"],
      "answer": "To indicate emotional tone"
    },
    {
      "question": "In sign language, what is the purpose of spatial referencing?",
      "options": ["To indicate locations or persons", "To represent past or future events", "To emphasize nouns", "To increase speed of signing"],
      "answer": "To indicate locations or persons"
    },
    {
      "question": "What is a classifier in sign language?",
      "options": ["An alphabet letter", "A technique for louder signing", "A handshape used to represent a specific object", "A system for teaching sign language"],
      "answer": "A handshape used to represent a specific object"
    },
    {
      "question": "Which of these refers to the movement of hands to form specific signs in sign language?",
      "options": ["Voicing", "Acting", "Signing", "Typing"],
      "answer": "Signing"
    },
    {
      "question": "What does the non-dominant hand usually do in two-handed signs?",
      "options": ["Stays idle", "Moves freely", "Indicates tense", "Supports the dominant hand"],
      "answer": "Supports the dominant hand"
    },
    {
      "question": "Which language is considered the first visual language that includes its own grammar and syntax, used by Deaf communities?",
      "options": ["American Sign Language (ASL)", "Written English", "Cued Speech", "Morse Code"],
      "answer": "American Sign Language (ASL)"
    },
    {
      "question": "What aspect of sign language allows for the expression of abstract concepts and ideas?",
      "options": ["Grammar", "Symbolic Representation", "Spatial Referencing", "Iconicity"],
      "answer": "Symbolic Representation"
    },
    {
      "question": "What is the name of the system that helps Deaf individuals learn to read lips and understand speech sounds?",
      "options": ["Braille", "Finger Spelling", "Oralism", "Cued Speech"],
      "answer": "Cued Speech"
    },
    {
      "question": "What is the primary language used by the Deaf community in the Philippines?",
      "options": ["Filipino Sign Language (FSL)", "American Sign Language (ASL)", "British Sign Language (BSL)", "Universal Sign Language"],
      "answer": "Filipino Sign Language (FSL)"
    },
    {
      "question": "Which device allows Deaf individuals to sense sounds through vibrations?",
      "options": ["Cochlear Implant", "Visual Alert System", "Tactile Sound Device", "Hearing Aid"],
      "answer": "Tactile Sound Device"
    },
    {
      "question": "What is the method where interpreters translate spoken language into sign language in real-time?",
      "options": ["Lip Reading", "Finger Spelling", "Simultaneous Interpretation", "Voice Recognition"],
      "answer": "Simultaneous Interpretation"
    },
    {
      "question": "Which of the following is NOT a communication method used by Deaf people?",
      "options": ["Oralism", "Sign Language", "Tactile Communication", "Telepathy"],
      "answer": "Telepathy"
    },
    {
      "question": "What is the name of the device that converts sign language into spoken language in real-time?",
      "options": ["Sign-to-Speech Converter", "Gesture Recognition System", "Voice Interpreter", "ASL Interpreter"],
      "answer": "Sign-to-Speech Converter"
    },
    {
      "question": "What is 'International Sign Language' primarily used for?",
      "options": ["Formal settings between Deaf individuals worldwide", "Casual conversations", "Only in the United States", "Only in Asia"],
      "answer": "Formal settings between Deaf individuals worldwide"
    },
    {
      "question": "What is one challenge of creating a universal sign language?",
      "options": ["Regional sign language differences", "Grammar is the same in all languages", "Sign languages have no facial expressions", "Signs are identical across languages"],
      "answer": "Regional sign language differences"
    },
    {
      "question": "In sign language, what does the term 'home sign' refer to?",
      "options": ["Sign language learned in schools", "Signs created by families without access to formal sign language", "Universal sign language", "Signs only used at home"],
      "answer": "Signs created by families without access to formal sign language"
    },
    {
      "question": "What is an important factor in recognizing emotions in sign language?",
      "options": ["Hand shape", "Facial expressions", "Speed of hand movements", "Number of signs used"],
      "answer": "Facial expressions"
    },
    {
      "question": "Which country is known for the 'Martha's Vineyard Sign Language'?",
      "options": ["United States", "Canada", "Australia", "Ireland"],
      "answer": "United States"
    },
    {
      "question": "What term describes the visual-spatial aspect of sign language?",
      "options": ["Iconicity", "Manualism", "Spatial Grammar", "Speech Reading"],
      "answer": "Spatial Grammar"
    },
    {
      "question": "Which area of the brain is typically associated with language processing in Deaf individuals using sign language?",
      "options": ["Left hemisphere", "Right hemisphere", "Both hemispheres", "No specific area"],
      "answer": "Left hemisphere"
    },
    {
      "question": "Which sign language is officially recognized in New Zealand?",
      "options": ["NZSL (New Zealand Sign Language)", "ASL", "BSL", "FSL"],
      "answer": "NZSL (New Zealand Sign Language)"
    },
    {
      "question": "What does 'Deaf Gain' refer to in Deaf culture?",
      "options": ["Advantages and contributions of Deaf culture", "Hearing loss severity", "Sign language vocabulary", "A type of cochlear implant"],
      "answer": "Advantages and contributions of Deaf culture"
    },
    {
      "question": "What is the difference between 'Deaf' and 'deaf'?",
      "options": ["'Deaf' refers to culture; 'deaf' refers to hearing loss", "No difference", "'Deaf' is a medical term", "'deaf' is a derogatory term"],
      "answer": "'Deaf' refers to culture; 'deaf' refers to hearing loss"
    },
    {
      "question": "What is a 'relay interpreter' in the context of sign language?",
      "options": ["An interpreter who works in teams", "A hearing interpreter", "An interpreter who conveys messages between sign languages", "An interpreter for non-verbal communication"],
      "answer": "An interpreter who conveys messages between sign languages"
    },
    {
      "question": "What is the purpose of a 'video relay service' (VRS) for Deaf individuals?",
      "options": ["To allow phone communication through interpreters", "To provide video calls only", "To teach sign language", "To record sign language lessons"],
      "answer": "To allow phone communication through interpreters"
    },
    {
      "question": "What is 'back-channeling' in sign language conversations?",
      "options": ["Using visual signals to show understanding", "Reversing signs", "Talking behind someone’s back", "Refusing to respond"],
      "answer": "Using visual signals to show understanding"
    },
    {
      "question": "What does 'manualism' refer to in Deaf education?",
      "options": ["Teaching with sign language", "Teaching with spoken language", "Learning through writing", "Lip reading"],
      "answer": "Teaching with sign language"
    },
    {
      "question": "What is a 'sign name' in Deaf culture?",
      "options": ["A unique sign given to a person", "A formal name", "A nickname used by hearing people", "An official document"],
      "answer": "A unique sign given to a person"
    },
    {
      "question": "Which hand movement is generally associated with questions in sign language?",
      "options": ["Raised eyebrows", "Shaking hands", "Closing fists", "Waving"],
      "answer": "Raised eyebrows"
    },
    {
      "question": "What is the primary focus of 'total communication' in Deaf education?",
      "options": ["Using multiple forms of communication", "Using only speech", "Using only sign language", "Relying on reading and writing"],
      "answer": "Using multiple forms of communication"
    },
    {
      "question": "What is the importance of eye contact in sign language?",
      "options": ["It shows attention and engagement", "It is used only for emphasis", "It replaces hand movements", "It is unnecessary"],
      "answer": "It shows attention and engagement"
    },
    {
      "question": "What does 'CODA' stand for in Deaf culture?",
      "options": ["Child of Deaf Adult", "Center of Deaf Activities", "Communication of Deaf Adults", "Community of Deaf Americans"],
      "answer": "Child of Deaf Adult"
    },
    {
      "question": "Which of these is a non-manual signal commonly used in sign language?",
      "options": ["Eyebrow movements", "Foot tapping", "Nose scratching", "Finger snapping"],
      "answer": "Eyebrow movements"
    },
    {
      "question": "What is the purpose of 'contrastive structure' in sign language?",
      "options": ["To show comparisons between ideas", "To emphasize nouns", "To increase signing speed", "To clarify grammar"],
      "answer": "To show comparisons between ideas"
    },
    {
      "question": "Which type of signing is primarily used in educational settings for deaf children?",
      "options": ["Signed Exact English", "Home Sign", "Fingerspelling", "Iconic Signing"],
      "answer": "Signed Exact English"
    },
    {
      "question": "What does 'ASL' stand for?",
      "options": ["American Sign Language", "American Speech Language", "Australian Sign Language", "Auditory Speech Language"],
      "answer": "American Sign Language"
    },
    {
      "question": "In which setting might tactile signing be most commonly used?",
      "options": ["With individuals who are deaf-blind", "During sports events", "In classroom settings", "In crowded places"],
      "answer": "With individuals who are deaf-blind"
    },
    {
      "question": "What does the term 'audism' refer to?",
      "options": ["Discrimination based on hearing ability", "A type of sign language", "An educational method", "A device for the Deaf"],
      "answer": "Discrimination based on hearing ability"
    },
    {
      "question": "What is one benefit of using finger spelling?",
      "options": ["It helps spell names and new words", "It replaces all signs", "It speeds up communication", "It removes facial expressions"],
      "answer": "It helps spell names and new words"
    },
    {
      "question": "Which hand is generally used as the dominant hand in ASL?",
      "options": ["Right or left, depending on personal preference", "Right only", "Left only", "Both hands at all times"],
      "answer": "Right or left, depending on personal preference"
    },
    {
      "question": "What does the 'handshape' parameter in sign language mean?",
      "options": ["Shape of the hands while signing", "Direction of hand movement", "Facial expressions", "Body posture"],
      "answer": "Shape of the hands while signing"
    },
    {
      "question": "Which technology is used to help Deaf individuals read live captions on TV?",
      "options": ["Closed Captioning", "Lip Reading", "Video Relay Service", "Facial Recognition"],
      "answer": "Closed Captioning"
    },
    {
      "question": "In sign language, what does 'iconic signs' mean?",
      "options": ["Signs that look like their meaning", "Signs with no relation to their meaning", "Only alphabet letters", "Gestures without specific meaning"],
      "answer": "Signs that look like their meaning"
    },
    {
      "question": "Which technique is used to teach spoken language to Deaf individuals?",
      "options": ["Oralism", "Manualism", "Spatial Referencing", "Iconicity"],
      "answer": "Oralism"
    },
    {
      "question": "Which organization in the U.S. is dedicated to supporting Deaf education and culture?",
      "options": ["National Association of the Deaf", "UNICEF", "WHO", "NATO"],
      "answer": "National Association of the Deaf"
    },
    {
      "question": "What is the purpose of a cochlear implant?",
      "options": ["To provide a sense of sound to individuals with hearing loss", "To enhance vision", "To translate languages", "To provide tactile sensations"],
      "answer": "To provide a sense of sound to individuals with hearing loss"
    },
    {
      "question": "What is one unique feature of sign language grammar?",
      "options": ["Topic-comment structure", "Subject-verb agreement", "Past tense markers", "Future tense markers"],
      "answer": "Topic-comment structure"
    },
    {
      "question": "What does 'Sign Supported English' involve?",
      "options": ["Using English word order in sign language", "Using only fingerspelling", "Replacing English grammar", "Using only iconic signs"],
      "answer": "Using English word order in sign language"
    },
    {
      "question": "In ASL, which facial expression is commonly associated with asking a question?",
      "options": ["Raised eyebrows", "Lowered eyebrows", "Smiling", "Frowning"],
      "answer": "Raised eyebrows"
    },
    {
      "question": "Which sign language is predominantly used in the United Kingdom?",
      "options": ["British Sign Language (BSL)", "American Sign Language (ASL)", "Filipino Sign Language (FSL)", "Australian Sign Language (Auslan)"],
      "answer": "British Sign Language (BSL)"
    },
    {
      "question": "What does the 'location' parameter refer to in sign language?",
      "options": ["Where the sign is performed on the body", "The speed of the sign", "The facial expression used", "The direction of the sign"],
      "answer": "Where the sign is performed on the body"
    },
    {
      "question": "What is the primary purpose of the Deaflympics?",
      "options": ["To allow Deaf athletes to compete internationally", "To promote lip-reading", "To teach sign language", "To train interpreters"],
      "answer": "To allow Deaf athletes to compete internationally"
    },
    {
      "question": "What does the term 'visual vernacular' refer to?",
      "options": ["A style of sign language storytelling", "A formal method of signing", "A type of captioning", "A form of lip-reading"],
      "answer": "A style of sign language storytelling"
    },
    {
      "question": "Which of these is commonly used in Deaf theater performances?",
      "options": ["Visual Vernacular", "Closed Captioning", "Tactile Signing", "Lip Reading"],
      "answer": "Visual Vernacular"
    },
    {
      "question": "In ASL, how is negation typically shown?",
      "options": ["By shaking the head", "By signing faster", "By using larger hand movements", "By signing with both hands"],
      "answer": "By shaking the head"
    },
    {
      "question": "What does the 'movement' parameter in sign language describe?",
      "options": ["How the hand moves during a sign", "The size of the sign", "The facial expression", "The length of the sign"],
      "answer": "How the hand moves during a sign"
    },
    {
      "question": "What is 'Tactile Signing' primarily used for?",
      "options": ["Communicating with deaf-blind individuals", "Teaching hearing individuals", "Using both hands to sign", "Signing at a distance"],
      "answer": "Communicating with deaf-blind individuals"
    },
    {
      "question": "Which type of video interpretation service allows Deaf individuals to communicate over the phone?",
      "options": ["Video Relay Service", "Closed Captioning", "Text Messaging", "Voice Relay Service"],
      "answer": "Video Relay Service"
    },
    {
      "question": "What is a common characteristic of Deaf culture?",
      "options": ["Strong sense of community and shared experiences", "Preference for isolation", "Emphasis on written communication", "Avoidance of visual language"],
      "answer": "Strong sense of community and shared experiences"
    },
    {
      "question": "What is the significance of 'Deaf President Now' (DPN) movement?",
      "options": ["A protest for a Deaf president at Gallaudet University", "A conference on Deaf education", "An art exhibit", "A film festival"],
      "answer": "A protest for a Deaf president at Gallaudet University"
    },
    {
      "question": "What is an interpreter's main role in a courtroom setting?",
      "options": ["To translate spoken language into sign language accurately", "To explain legal terms", "To act as a lawyer", "To record the proceedings"],
      "answer": "To translate spoken language into sign language accurately"
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
  final int _totalQuestions = 10;
  Timer? _timer;
  int _timeLeft = 30;

  // Feedback mechanism history
  static final List<int> _quizHistory = [];
  bool _isQuizComplete = false; // Added flag

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

    _questions = [...letterImageQuestions, ..._questionsData]..shuffle();
    _questions = _questions.sublist(0, _totalQuestions);
    _currentQuestionIndex = 0;
    _correctAnswers = 0;
    _selectedAnswer = null;
    _showFeedback = false;
    _isQuizComplete = false; // Reset flag
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
    if (_isQuizComplete) return; // Prevent duplicate prompts
    _isQuizComplete = true; // Set the flag

    _quizHistory.add(_correctAnswers);
    String improvementFeedback = "No previous data to compare.";

    if (_quizHistory.length > 1) {
      int previousScore = _quizHistory[_quizHistory.length - 2];
      if (_correctAnswers > previousScore) {
        improvementFeedback = "🎉 Great job! You've improved compared to your last quiz.";
      } else if (_correctAnswers == previousScore) {
        improvementFeedback = "👍 Good effort! Your performance is consistent.";
      } else {
        improvementFeedback = "💪 Keep practicing! You'll improve with more attempts.";
      }
    }

    int totalWrong = _totalQuestions - _correctAnswers;
    int completion = _totalQuestions > 0 ? ((_correctAnswers / _totalQuestions) * 100).round() : 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Text(
                  "${_correctAnswers * 10}",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Quiz Completed!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Text(
                improvementFeedback,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _scoreInfo(Icons.check_circle, "Correct", _correctAnswers, Colors.green),
                  _scoreInfo(Icons.cancel, "Wrong", totalWrong, Colors.red),
                ],
              ),
              const Divider(height: 30, thickness: 1, color: Colors.grey),
              Text(
                "Completion: $completion%",
                style: const TextStyle(fontSize: 18, color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _initializeQuiz();
                      _startTimer();
                    });
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.replay),
                  label: const Text("Retry"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white, // Makes text and icons white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.home),
                  label: const Text("Home"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white, // Makes text and icons white
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

              ],
            ),
          ],
        );
      },
    );
  }

  Widget _scoreInfo(IconData icon, String label, int value, Color color) {
    return Column(
      children: [
        Icon(icon, size: 36, color: color),
        const SizedBox(height: 5),
        Text(
          "$value",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isImageQuestion = _questions[_currentQuestionIndex].containsKey('image');

    return WillPopScope(
      onWillPop: () async {
        // Prevent the user from navigating back
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Language Quiz'),
          backgroundColor: Colors.blue[700],
          automaticallyImplyLeading: false, // Remove the back button
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
      ),
    );
  }
}
