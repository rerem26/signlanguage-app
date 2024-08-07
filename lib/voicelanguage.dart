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
  List<List<int>> _wordsIndexes = [];
  String _error = '';
  List<String> _letters = [];
  Timer? _timer;
  int _currentLetterIndex = 0;
  String _selectedLanguage = 'en_US'; // Default to English

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

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

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

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
        onPressed: _speechToText.isListening ? _stopListening : _startListening,
        tooltip: 'Listen',
        child: Icon(_speechToText.isListening ? Icons.mic_off : Icons.mic),
      ),
    );
  }
}
