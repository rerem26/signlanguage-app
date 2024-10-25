import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async';
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
  String _currentLocaleId = 'en-US'; // Default locale to English

  TextEditingController _textController = TextEditingController(); // Controller for text input

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
          icon: Icon(Icons.arrow_back, color: Colors.black),
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
          // This is the section that will be at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                  hintStyle: TextStyle(
                    color: Colors.grey, // Subtle hint color
                  ),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic, color: Colors.black), // Microphone icon
                        onPressed: _listen, // Calls the _listen function when pressed
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue), // Send icon
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
                    borderSide: BorderSide(
                      color: Colors.black, // Purple border when the field is focused
                      width: 2.0,
                    ),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Padding inside the TextField
                ),
                style: TextStyle(
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
          localeId: _currentLocaleId, // Use the selected locale
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
    // This regex replaces sequences of repeated characters with just one character
    // Example: "mahalllllll" becomes "mahal"
    return input.replaceAllMapped(RegExp(r'(\w)\1{2,}'), (Match match) {
      return match.group(1)!; // Replace with the first occurrence of the character
    });
  }

  void _submitMessage() {
    setState(() {
      _text = _textController.text;
      _text = _cleanText(_text); // Clean the text before translating
      translation(_text);
      _textController.clear(); // Clear the text field after submission
    });
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
          _path = 'assets/gif/';
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
