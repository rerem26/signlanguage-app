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
      onStatus: (val) {
        if (val == "done" && _isListening) {
          // Restart listening if it stops unexpectedly
          _restartListening();
        }
      },
      onError: (val) => print('onError: $val'),
      debugLogging: true,
    );

    if (available) {
      // Get the available locales (languages) and set to Filipino if available
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
          // Toggle button to switch between English and Filipino
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
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 30.0), // Increased bottom padding to lift up the TextField
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
                  fillColor: Colors.grey[200], // Light grey background for the TextField
                  hintText: 'Enter message',
                  hintStyle: const TextStyle(
                    color: Colors.grey, // Subtle hint color
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.mic, color: Colors.black), // Microphone icon
                        onPressed: _listen, // Calls the _listen function when pressed
                      ),
                      IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue), // Send icon
                        onPressed: _submitMessage, // Submit message when the send button is pressed
                      ),
                    ],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0), // Rounded corners
                    borderSide: BorderSide.none, // No border line for a clean look
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: const BorderSide(
                      color: Colors.black, // Black border when the field is focused
                      width: 2.0,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Padding inside the TextField
                ),
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black, // Black text color
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize(
        onStatus: (val) {
          if (val == "done" && _isListening) {
            Future.delayed(Duration(milliseconds: 500), () {
              if (_isListening) _restartListening();
            });
          }
        },
        onError: (val) => print('onError: $val'),
        debugLogging: true,
      );

      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(
          onResult: (val) => setState(() {
            _text = _cleanText(val.recognizedWords);
            _displaytext = _text; // Update displayed text in real-time
          }),
          localeId: _currentLocaleId,
          partialResults: true, // Allow partial results for real-time feedback
          listenFor: Duration(minutes: 1), // Set a longer timeout
          pauseFor: Duration(seconds: 3), // Set a pause timeout to keep listening during short pauses
        );
      }
    } else {
      setState(() => _isListening = false);
      _speechToText.stop();
      translation(_text); // Perform translation once the user stops
      _state = 0;
    }
  }

  void _restartListening() {
    if (_isListening) {
      _speechToText.listen(
        onResult: (val) => setState(() {
          _text = _cleanText(val.recognizedWords);
          _displaytext = _text;
        }),
        localeId: _currentLocaleId,
        partialResults: true,
        listenFor: Duration(minutes: 1),
        pauseFor: Duration(seconds: 3),
      );
    }
  }

  String _cleanText(String input) {
    // Remove sequences of repeated characters
    return input.replaceAllMapped(RegExp(r'(\w)\1{2,}'), (Match match) {
      return match.group(1)!;
    });
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
            setState(() {
              _state += 1;
              _displaytext += ' ';
              _path = 'assets/letters/';
              _img = 'space';
              _ext = '.png';
            });
            await Future.delayed(const Duration(milliseconds: 1000));
          }
        }
      }
    }
  }
}
