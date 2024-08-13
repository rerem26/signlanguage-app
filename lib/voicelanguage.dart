import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
  List<List<int>> _wordsIndexes = [];
  String _error = '';
  List<String> _letters = [];
  Timer? _timer;
  int _currentLetterIndex = 0;
  String _selectedLanguage = 'en_US'; // Default to English

  // Variables to hold the loaded JSON data
  Map<String, dynamic>? msaslClasses;
  Map<String, dynamic>? msaslSynonym;
  Map<String, dynamic>? msaslTest;
  Map<String, dynamic>? msaslTrain;
  Map<String, dynamic>? msaslVal;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _loadAllJsons(); // Load the JSON data when the widget is initialized
  }

  // Initialize Speech-to-Text
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => setState(() {
        _error = val.errorMsg;
      }),
      onStatus: (val) => setState(() {
        // handle status changes if needed
      }),
    );
    setState(() {});
  }

  // Load JSON files
  Future<Map<String, dynamic>> loadJsonData(String fileName) async {
    String jsonString = await rootBundle.loadString('assets/$fileName');
    final jsonResponse = json.decode(jsonString);
    return jsonResponse;
  }

  Future<void> _loadAllJsons() async {
    msaslClasses = await loadJsonData('MSASL_classes.json');
    msaslSynonym = await loadJsonData('MSASL_synonym.json');
    msaslTest = await loadJsonData('MSASL_test.json');
    msaslTrain = await loadJsonData('MSASL_train.json');
    msaslVal = await loadJsonData('MSASL_val.json');

    // You can now use the loaded JSON data within your widget
    print(msaslClasses);
    print(msaslSynonym);
    print(msaslTest);
    print(msaslTrain);
    print(msaslVal);

    setState(() {}); // Call setState to trigger a rebuild if needed
  }

  // Start listening to voice input
  void _startListening() async {
    if (_speechEnabled) {
      setState(() {
        _lastWords = '';
      });
      await _speechToText.listen(
        onResult: _onSpeechResult,
        localeId: _selectedLanguage,
      );
    }
    setState(() {});
  }

  // Stop listening to voice input
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  // Handle speech result
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      _wordsIndexes = _convertWordsToIndexes(_lastWords);

      // Initialize _letters with the recognized words
      _letters = _lastWords.split('');

      // Start slideshow automatically when words are recognized
      if (_wordsIndexes.isNotEmpty) {
        _startSlideshowDelayed();
      }
    });
  }

  // Convert recognized words to indexes
  List<List<int>> _convertWordsToIndexes(String words) {
    return words
        .split(' ')
        .map((word) => word
        .toUpperCase()
        .codeUnits
        .map((unit) => unit - 65)
        .toList())
        .toList();
  }

  // Start slideshow with delay
  void _startSlideshowDelayed() {
    if (_timer != null) {
      _timer!.cancel();
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentLetterIndex++;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
            if (_letters.isNotEmpty) ...[
              SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Signs for '${_letters[_currentLetterIndex % _letters.length]}'",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:
        _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
