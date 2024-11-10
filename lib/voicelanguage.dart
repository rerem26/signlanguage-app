import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';
import 'utils.dart'; // Import your utils class or file

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Voice to Sign Language',
      home: Voice_To_Sign(),
    );
  }
}

class Voice_To_Sign extends StatefulWidget {
  const Voice_To_Sign({super.key});

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
  String _currentLocaleId = 'en-US'; // Default locale to English

  final TextEditingController _textController = TextEditingController(); // Controller for text input

  @override
  void initState() {
    super.initState();
    _speechToText = SpeechToText();
    _initSpeech();
  }

  // Initialize speech recognition and check for available locales (languages)
  void _initSpeech() async {
    bool available = await _speechToText.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
      debugLogging: true,
    );

    if (available) {
      var locales = await _speechToText.locales();
      for (var locale in locales) {
        if (locale.localeId == 'fil-PH') {
          setState(() {
            _currentLocaleId = 'fil-PH';
          });
          break;
        }
      }
    }
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            onSelected: (String value) {
              setState(() {
                _currentLocaleId = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'en-US',
                child: Text('English'),
              ),
              const PopupMenuItem<String>(
                value: 'fil-PH',
                child: Text('Filipino'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(0, 0.0, 0, 0.0),
                    width: MediaQuery.of(context).size.width,
                    height: (4 / 3) * MediaQuery.of(context).size.width,
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
                      child: SizedBox(
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0), // Increased padding to raise input field
            child: RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: (event) {
                if (event.isKeyPressed(LogicalKeyboardKey.enter)) {
                  _submitMessage();
                }
              },
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: 'Enter message',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mic_rounded, color: Colors.black),
                        onPressed: _listen,
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _submitMessage,
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black,
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20.0), // Additional padding to push the input field up
        ],
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
        _speechToText.listen(
          onResult: (val) => setState(() {
            _text = _cleanText(val.recognizedWords);
          }),
          localeId: _currentLocaleId,
          listenFor: Duration(seconds: 15), // Extended duration to capture complete input
          partialResults: false, // Only take the final result to reduce noise
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
      translation(_text);
      _state = 0;
    }
  }

  String _cleanText(String input) {
    // Removes repeated characters and filters out isolated characters
    String result = input.replaceAllMapped(RegExp(r'(\w)\1{2,}'), (match) {
      return match.group(1)!;
    });

    // Remove any single letters that aren’t 'a' or 'i', which are common in Filipino and English
    result = result.replaceAll(RegExp(r'\b(?![ai])\w\b'), '');

    return result;
  }

  void _submitMessage() {
    setState(() {
      _text = _textController.text;
      _text = _cleanText(_text);
      translation(_text);
      _textController.clear();
    });
  }

  void translation(String text) async {
    _displaytext = '';
    String speechStr = text.toLowerCase();

    List<String> strArray = speechStr.split(" ");
    for (String content in strArray) {
      if (words.contains(content)) {
        String file = content;
        int idx = words.indexOf(content);
        int duration = int.parse(words.elementAt(idx + 1));

        setState(() {
          _state += 1;
          _displaytext += content;
          _path = 'assets/gif/';
          _img = file;
          _ext = '.gif';
        });
        await Future.delayed(Duration(milliseconds: duration));
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
