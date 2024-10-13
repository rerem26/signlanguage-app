import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';
import 'package:avatar_glow/avatar_glow.dart'; // Ensure avatar_glow is added in pubspec.yaml
import 'utils.dart'; // Import your utils class or file

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
  bool _isListening = false;
  String _text = '';
  String _img = 'space';
  String _ext = '.png';
  String _path = 'assets/letters/';
  String _displaytext = 'Press the button and start speaking...';
  int _state = 0;

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Voice to Sign Language',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Image(
                      image: AssetImage('$_path$_img$_ext'),
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      key: ValueKey<int>(_state),
                      width: MediaQuery.of(context).size.width,
                      height: (4 / 3) * MediaQuery.of(context).size.width,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: (4 / 3) * MediaQuery.of(context).size.width,
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 0),
                  child: SingleChildScrollView(
                    reverse: true,
                    physics: const AlwaysScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    child: Container(
                      height: 0.04 * MediaQuery.of(context).size.height,
                      child: Text(
                        _displaytext,
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                  color: Colors.black,
                  indent: 20,
                  endIndent: 20,
                ),
              ],
            ),
          ),
        ),
        onRefresh: () {
          return Future.delayed(
            const Duration(seconds: 1),
                () {
              setState(() {
                _text = '';
                _path = 'assets/letters/';
                _img = 'space';
                _ext = '.png';
                _displaytext = 'Press the button and start speaking...';
                _state = 0;
              });
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: FloatingActionButton(
          onPressed: _listen,
          child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
        debugLogging: true,
      );

      if (available) {
        setState(() => _isListening = true);
        // Here we specify English or Filipino as supported languages
        _speechToText.listen(
          onResult: (val) => setState(() {
            _text = val.recognizedWords;
          }),
          localeId: 'en-US', // Use 'fil-PH' for Filipino, change dynamically if needed
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
      translation(_text);
      _state = 0;
    }
  }

  void translation(String _text) async {
    _displaytext = '';
    String speechStr = _text.toLowerCase();

    List<String> strArray = speechStr.split(" ");
    for (String content in strArray) {
      if (words.contains(content)) {
        String file = content;
        int idx = words.indexOf(content);
        int _duration = int.parse(words.elementAt(idx + 1));

        setState(() {
          _state += 1;
          _displaytext += content;
          _path = 'assets/ISL_Gifs/';
          _img = file;
          _ext = '.gif';
        });
        await Future.delayed(Duration(milliseconds: _duration));
      } else {
        for (var i = 0; i < content.length; i++) {
          if (letters.contains(content[i])) {
            String char = content[i];
            setState(() {
              _state += 1;
              _displaytext += char;
              _path = 'assets/letters/';
              _img = char;
              _ext = '.png';
            });
            await Future.delayed(const Duration(milliseconds: 1500));
          } else {
            String letter = content[i];
            setState(() {
              _state += 1;
              _displaytext += letter;
              _path = 'assets/letters/';
              _img = 'space';
              _ext = '.png';
            });
            await Future.delayed(const Duration(milliseconds: 1000));
          }
        }
      }
      setState(() {
        _state += 1;
        _displaytext += " ";
        _path = 'assets/letters/';
        _img = 'space';
        _ext = '.png';
      });
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }
}
