import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice to Sign Language',
      home: Voice_To_Sign(),
    );
  }
}

class Voice_To_Sign extends StatefulWidget {
  @override
  _VoiceToSignState createState() => _VoiceToSignState();
}

class _VoiceToSignState extends State<Voice_To_Sign> {
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  List<String> _recognizedWords = [];
  String _error = '';
  Timer? _animationTimer;

  // Mapping words and letters to their corresponding gesture assets
  final Map<String, String> _gestureAssets = {
    'A': 'assets/A.png',
    'B': 'assets/B.png',
    'C': 'assets/C.png',
    'D': 'assets/D.png',
    'E': 'assets/E.png',
    'F': 'assets/F.png',
    'G': 'assets/G.png',
    'H': 'assets/H.png',
    'I': 'assets/I.png',
    'J': 'assets/J.png',
    'K': 'assets/K.png',
    'L': 'assets/L.png',
    'M': 'assets/M.png',
    'N': 'assets/N.png',
    'O': 'assets/O.png',
    'P': 'assets/P.png',
    'Q': 'assets/Q.png',
    'R': 'assets/R.png',
    'S': 'assets/S.png',
    'T': 'assets/T.png',
    'U': 'assets/U.png',
    'V': 'assets/V.png',
    'W': 'assets/W.png',
    'X': 'assets/X.png',
    'Y': 'assets/Y.png',
    'Z': 'assets/Z.png',
    // Add more word-to-gesture mappings here
    'HELLO': 'assets/HELLO.png',
    'WORLD': 'assets/WORLD.png',
    // You can add more mappings for words here
  };

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  // Initialize Speech-to-Text
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => setState(() {
        _error = val.errorMsg;
      }),
    );
    setState(() {});
  }

  // Start listening to voice input
  void _startListening() async {
    if (_speechEnabled) {
      setState(() {
        _lastWords = '';
        _recognizedWords.clear();
      });
      await _speechToText.listen(
        onResult: _onSpeechResult,
        partialResults: true,
        listenMode: ListenMode.dictation,
      );
    }
    setState(() {});
  }

  // Stop listening to voice input
  void _stopListening() async {
    await _speechToText.stop();
    _animationTimer?.cancel();
    setState(() {});
  }

  // Handle speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult || result.confidence > 0.8) {
      setState(() {
        _lastWords = result.recognizedWords.toUpperCase();
        _recognizedWords = _lastWords.split(' '); // Split the recognized speech into words

        // Start animation when words are recognized
        if (_recognizedWords.isNotEmpty) {
          _startWordAnimation();
        }
      });
    }
  }

  // Start word animation with a brief delay for smooth transition
  void _startWordAnimation() {
    _animationTimer?.cancel(); // Cancel any existing timer

    int wordIndex = 0;
    _animationTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (wordIndex < _recognizedWords.length) {
        String word = _recognizedWords[wordIndex];
        wordIndex++;
        setState(() {
          // Display the gesture corresponding to the recognized word
          _recognizedWords = [word];
        });
      } else {
        _animationTimer!.cancel();
      }
    });
  }

  // Build the gesture animation widget
  Widget _buildGestureAnimation() {
    if (_recognizedWords.isEmpty) return SizedBox.shrink();

    String currentWord = _recognizedWords.first;
    List<Widget> gestureWidgets = [];

    // Check if the current word has a corresponding gesture
    if (_gestureAssets.containsKey(currentWord)) {
      gestureWidgets.add(Image.asset(_gestureAssets[currentWord]!, width: 200, height: 200));
    } else {
      // If the word doesn't have a corresponding gesture, break it into letters
      for (var letter in currentWord.split('')) {
        if (_gestureAssets.containsKey(letter)) {
          gestureWidgets.add(Image.asset(_gestureAssets[letter]!, width: 50, height: 50));
        }
      }
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: gestureWidgets,
    );
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice to Sign Language'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(16),
              child: Text(
                'Recognized words:',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(16),
                child: _speechToText.isListening
                    ? Text(
                  _lastWords,
                  style: TextStyle(fontSize: 24),
                )
                    : _speechEnabled
                    ? Text(
                  'Tap the microphone to start listening...',
                  style: TextStyle(fontSize: 24),
                )
                    : Text(
                  'Speech not available',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            if (_error.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Error: $_error',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            if (_recognizedWords.isNotEmpty) ...[
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: _buildGestureAnimation(),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isListening ? Icons.mic : Icons.mic_off),
      ),
    );
  }
}
