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
      {
        "question": "What is the sign language for 'HELLO'?",
        "options": ["Cross arms", "Make a fist", "Point to the ground", "Wave hand near forehead"],
        "answer": "Wave hand near forehead",
        "image": "assets/hello.png"
      },
      {
        "question": "What is the sign language for 'GOODBYE'?",
        "options": ["Thumbs up", "Point to mouth", "Wave hand", "Cross fingers"],
        "answer": "Wave hand",
        "image": "assets/goodbye.png"
      },
      {
        "question": "What is the sign language for 'PLEASE'?",
        "options": ["Tap your nose", "Move hand in a circular motion on chest", "Point to the sky", "Clap hands"],
        "answer": "Move hand in a circular motion on chest",
        "image": "assets/please.png"
      },
      {
        "question": "What is the sign language for 'NO'?",
        "options": ["Wave both hands", "Tap index and middle finger together", "Shake head", "Thumbs down"],
        "answer": "Tap index and middle finger together",
        "image": "assets/no.png"
      },
      {
        "question": "What is the sign language for 'YES'?",
        "options": ["Cross arms", "Make a fist and nod", "Tap shoulder", "Wave hand"],
        "answer": "Make a fist and nod",
        "image": "assets/yes.png"
      },
      {
        "question": "What is the sign language for 'THANK YOU'?",
        "options": ["Cross fingers", "Move hand outward from chin", "Wave hand", "Thumbs up"],
        "answer": "Move hand outward from chin",
        "image": "assets/thankyou.png"
      },
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
        "question": "In which country is Filipino Sign Language (FSL) primarily used?",
        "options": ["Japan", "Philippines", "United States", "France"],
        "answer": "Philippines"
      },
      {
        "question": "What is the primary goal of 'Oralism' in Deaf education?",
        "options": ["Using Sign Language", "Training Speech and Lip-Reading", "Using Technology", "Learning to Write"],
        "answer": "Training Speech and Lip-Reading"
      },
      {
        "question": "Which device converts sound into electrical signals to stimulate the auditory nerve?",
        "options": ["Hearing Aid", "Sound Amplifier", "Cochlear Implant", "Visual Alert System"],
        "answer": "Cochlear Implant"
      },
      {
        "question": "What is 'Finger Spelling' primarily used for?",
        "options": ["Describe Emotions", "Sign Names", "Represent Letters", "Communicate Gestures"],
        "answer": "Represent Letters"
      },
      {
        "question": "Which system uses handshapes near the mouth to visually distinguish sounds?",
        "options": ["Cued Speech", "Finger Spelling", "Lip Reading", "Oralism"],
        "answer": "Cued Speech"
      },
      {
        "question": "What is the primary language used by the Deaf community in the United States?",
        "options": ["British Sign Language (BSL)", "Filipino Sign Language (FSL)", "American Sign Language (ASL)", "Universal Sign Language"],
        "answer": "American Sign Language (ASL)"
      },
      {
        "question": "What is the purpose of 'closed captioning' on television or video?",
        "options": ["Improve video quality", "Provide subtitles", "Translate languages", "Show facial expressions"],
        "answer": "Provide subtitles"
      },
      {
        "question": "Which assistive device amplifies sound for people with mild to moderate hearing loss?",
        "options": ["Hearing Aid", "Cochlear Implant", "Visual Alert System", "Tactile Sound Device"],
        "answer": "Hearing Aid"
      },
      {
        "question": "What is the main purpose of sign language interpreters?",
        "options": ["To teach sign language", "To replace written language", "To assist with hearing", "To translate spoken language into sign language"],
        "answer": "To translate spoken language into sign language"
      },
      {
        "question": "What is a common way for Deaf individuals to communicate over the phone?",
        "options": ["Video Relay Service", "Telegraph", "Texting", "Lip Reading"],
        "answer": "Video Relay Service"
      },
      {
        "question": "What is the role of a 'Deaf mentor' in the Deaf community?",
        "options": ["To interpret sign language", "To guide learning and support in Deaf culture", "To help with financial planning", "To provide therapy"],
        "answer": "To guide learning and support in Deaf culture"
      },
      {
        "question": "Which of these is a visual alert system often used by Deaf individuals?",
        "options": ["Cochlear Implant", "Vibrating Pager", "Visual Alert System", "Finger Spelling"],
        "answer": "Visual Alert System"
      },
      {
        "question": "What does 'Total Communication' in Deaf education emphasize?",
        "options": ["Only using sign language", "Combining sign language, speech, and other communication methods", "Using oral speech only", "Relying on writing"],
        "answer": "Combining sign language, speech, and other communication methods"
      },
      {
        "question": "Which of the following is a common manual alphabet used by Deaf people?",
        "options": ["American Sign Language", "Braille", "Finger Spelling", "Speech Reading"],
        "answer": "Finger Spelling"
      },
      {
        "question": "Which approach focuses on integrating Deaf students into mainstream classrooms?",
        "options": ["Oralism", "Inclusion", "Manualism", "Simultaneous Communication"],
        "answer": "Inclusion"
      },
      {
        "question": "What is the main challenge for machine learning models in recognizing sign language from videos?",
        "options": ["Capturing finger details", "Detecting sound", "Recording video in low light", "Translating written text"],
        "answer": "Capturing finger details"
      },
      {
        "question": "Which technique is commonly used to track hand movements in sign language recognition systems?",
        "options": ["Image segmentation", "Sound processing", "Text analysis", "Facial recognition"],
        "answer": "Image segmentation"
      },
      {
        "question": "In sign language recognition, which data type is often used as input for training machine learning models?",
        "options": ["Images or video frames", "Audio files", "Text documents", "Spreadsheets"],
        "answer": "Images or video frames"
      },
      {
        "question": "Which machine learning model is frequently used for gesture recognition in sign language?",
        "options": ["Convolutional Neural Networks (CNN)", "Recurrent Neural Networks (RNN)", "Naive Bayes", "Support Vector Machine (SVM)"],
        "answer": "Convolutional Neural Networks (CNN)"
      },
      {
        "question": "What is the purpose of feature extraction in sign language recognition systems?",
        "options": ["To simplify input data", "To improve video quality", "To speed up hand movement", "To remove background noise"],
        "answer": "To simplify input data"
      },
      {
        "question": "Which algorithm is often combined with CNNs to understand the sequence of hand movements in sign language?",
        "options": ["Long Short-Term Memory (LSTM)", "K-Nearest Neighbors", "Linear Regression", "Decision Trees"],
        "answer": "Long Short-Term Memory (LSTM)"
      },
      {
        "question": "Why are datasets of various hand shapes and movements important in training sign language models?",
        "options": ["To ensure diverse gesture recognition", "To reduce model size", "To improve text quality", "To minimize sound error"],
        "answer": "To ensure diverse gesture recognition"
      },
      {
        "question": "What is one of the key challenges in training machine learning models for sign language recognition?",
        "options": ["Labeling gestures accurately", "Generating random numbers", "Simplifying sentences", "Optimizing sound recognition"],
        "answer": "Labeling gestures accurately"
      },
      {
        "question": "Which type of neural network layer is especially effective at recognizing spatial relationships in sign language images?",
        "options": ["Convolutional layers", "Dropout layers", "Dense layers", "Recurrent layers"],
        "answer": "Convolutional layers"
      },
      {
        "question": "In sign language translation, what is the advantage of using 3D cameras for data collection?",
        "options": ["Captures depth and hand positioning more accurately", "Improves sound quality", "Increases video playback speed", "Reduces model size"],
        "answer": "Captures depth and hand positioning more accurately"
      },
      {
        "question": "Which machine learning technique can improve the accuracy of sign language recognition by capturing temporal patterns?",
        "options": ["Recurrent Neural Networks (RNNs)", "Decision Trees", "Linear Regression", "Support Vector Machines (SVM)"],
        "answer": "Recurrent Neural Networks (RNNs)"
      },
      {
        "question": "What is a critical aspect of training datasets for machine learning models focused on sign language?",
        "options": ["Diversity in sign language gestures", "Clarity of spoken words", "Length of sentences", "Quality of background music"],
        "answer": "Diversity in sign language gestures"
      },
      {
        "question": "In real-time sign language recognition systems, which factor is essential for smooth performance?",
        "options": ["Low latency in processing frames", "High sound volume", "Complex background images", "Vibrant colors"],
        "answer": "Low latency in processing frames"
      },
      {
        "question": "Which data preprocessing step is commonly applied to sign language images for machine learning?",
        "options": ["Resizing and normalization", "Sound equalization", "Text parsing", "Color inversion"],
        "answer": "Resizing and normalization"
      },
      {
        "question": "What does transfer learning offer in developing a sign language recognition system?",
        "options": ["Faster model training by reusing pre-trained networks", "Converting text to audio", "Generating random hand signs", "Increasing video resolution"],
        "answer": "Faster model training by reusing pre-trained networks"
      },
      {
        "question": "Why is data augmentation helpful in building a sign language recognition model?",
        "options": ["It increases the diversity of training samples", "It reduces the number of frames needed", "It speeds up audio processing", "It reduces video file size"],
        "answer": "It increases the diversity of training samples"
      },
      {
        "question": "What type of output can a machine learning-based sign language translator provide?",
        "options": ["Text or speech output", "Vibrations", "Hand movements", "Weather updates"],
        "answer": "Text or speech output"
      },
      {
        "question": "In gesture-based machine learning, what is the role of hand landmark detection?",
        "options": ["Identifying key points of the hand for accurate recognition", "Increasing sound quality", "Tracking text movement", "Adjusting color levels"],
        "answer": "Identifying key points of the hand for accurate recognition"
      },
      {
        "question": "Which deep learning architecture is best suited for analyzing both spatial and temporal information in sign language videos?",
        "options": ["3D Convolutional Neural Networks (3D CNNs)", "Support Vector Machines", "Naive Bayes", "Logistic Regression"],
        "answer": "3D Convolutional Neural Networks (3D CNNs)"
      },
      {
        "question": "What type of neural network is often used to capture sequential dependencies in sign language movements?",
        "options": ["Recurrent Neural Networks (RNNs)", "Convolutional Neural Networks (CNNs)", "Feedforward Neural Networks", "Random Forest"],
        "answer": "Recurrent Neural Networks (RNNs)"
      },
      {
        "question": "What is the primary benefit of using data augmentation techniques in sign language datasets?",
        "options": ["Expanding the dataset variety without additional data collection", "Increasing sound clarity", "Reducing frame rate", "Improving facial recognition accuracy"],
        "answer": "Expanding the dataset variety without additional data collection"
      },
      {
        "question": "Which loss function is commonly used for multi-class classification tasks in sign language recognition?",
        "options": ["Categorical Cross-Entropy", "Mean Squared Error", "Binary Cross-Entropy", "Huber Loss"],
        "answer": "Categorical Cross-Entropy"
      },
      {
        "question": "Which method helps reduce overfitting in large neural networks used for sign language recognition?",
        "options": ["Dropout Regularization", "Batch Normalization", "Early Stopping", "Gradient Clipping"],
        "answer": "Dropout Regularization"
      },
      {
        "question": "What is one of the primary purposes of normalization in sign language image preprocessing?",
        "options": ["To scale pixel values for better model performance", "To improve audio quality", "To highlight hand gestures", "To increase frame size"],
        "answer": "To scale pixel values for better model performance"
      },
      {
        "question": "Which model evaluation metric is particularly useful for imbalanced datasets in sign language recognition?",
        "options": ["F1 Score", "Mean Absolute Error", "Mean Squared Error", "Log Loss"],
        "answer": "F1 Score"
      },
      {
        "question": "Why are facial expressions also important in sign language recognition models?",
        "options": ["They add emotional context to the signs", "They increase image contrast", "They add background details", "They simplify the recognition process"],
        "answer": "They add emotional context to the signs"
      },
      {
        "question": "Which approach can help improve real-time sign language recognition in low-light conditions?",
        "options": ["Using infrared cameras", "Increasing frame rate", "Adding subtitles", "Reducing noise"],
        "answer": "Using infrared cameras"
      },
      {
        "question": "In sign language recognition, what is the main purpose of transfer learning?",
        "options": ["To apply knowledge from pre-trained models to new tasks", "To improve audio processing", "To increase data size", "To reduce hand movement"],
        "answer": "To apply knowledge from pre-trained models to new tasks"
      },
      {
        "question": "What is a common challenge when training machine learning models with 3D gesture data for sign language?",
        "options": ["High computational cost", "Poor sound quality", "Difficulty in labeling audio data", "Low frame rate"],
        "answer": "High computational cost"
      },
      {
        "question": "What is one benefit of using skeleton-based models in sign language recognition?",
        "options": ["They reduce data complexity by focusing only on joint positions", "They enhance image quality", "They improve text clarity", "They require less training data"],
        "answer": "They reduce data complexity by focusing only on joint positions"
      },
      {
        "question": "Which tool is commonly used to annotate hand gestures for training sign language recognition models?",
        "options": ["LabelImg", "WaveSurfer", "Sound Forge", "TranscriberAG"],
        "answer": "LabelImg"
      },
      {
        "question": "In sign language recognition, what is the role of 'keypoint detection'?",
        "options": ["Identifying specific hand and finger positions", "Improving sound quality", "Increasing video resolution", "Adding subtitles"],
        "answer": "Identifying specific hand and finger positions"
      },
      {
        "question": "Which dataset would be most useful for training a sign language recognition model?",
        "options": ["Annotated videos of hand gestures", "Audio recordings", "Text documents", "Stock images"],
        "answer": "Annotated videos of hand gestures"
      },
      {
        "question": "What is one of the advantages of using temporal features in sign language recognition?",
        "options": ["Capturing the flow of gestures over time", "Increasing model size", "Reducing data requirements", "Enhancing audio clarity"],
        "answer": "Capturing the flow of gestures over time"
      },
      {
        "question": "Why is hand segmentation an important step in sign language recognition?",
        "options": ["To focus on the hands and ignore background noise", "To improve color depth", "To increase video resolution", "To simplify facial recognition"],
        "answer": "To focus on the hands and ignore background noise"
      },
      {
        "question": "In a sign language recognition system, why is it useful to detect the hand’s orientation?",
        "options": ["Orientation affects the meaning of signs", "It increases video contrast", "It simplifies text processing", "It improves sound quality"],
        "answer": "Orientation affects the meaning of signs"
      },
      {
        "question": "Which component is essential for real-time sign language recognition in mobile applications?",
        "options": ["Optimized lightweight model", "High-resolution camera", "Background music", "External microphone"],
        "answer": "Optimized lightweight model"
      },
      {
        "question": "What is a key advantage of using Convolutional Neural Networks (CNNs) for image-based sign language recognition?",
        "options": ["They automatically extract spatial features from images", "They increase data resolution", "They simplify audio processing", "They reduce the need for labels"],
        "answer": "They automatically extract spatial features from images"
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
