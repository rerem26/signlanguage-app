import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;  // Add the http package
import 'dart:convert';

import 'main.dart';  // Add this for json encoding/decoding

class SignText extends StatefulWidget {
  @override
  _SignTextState createState() => _SignTextState();
}

class _SignTextState extends State<SignText> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraPermissionGranted = false;
  String detectedGesture = "No gesture detected";
  String translation = "No translation available";

  List<String> words = [/* Your English and Tagalog words here */];
  int currentWordIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _simulateWordDetection(); // Simulate word detection
  }

  Future<void> _initCamera() async {
    await _requestCameraPermission();
    if (_isCameraPermissionGranted) {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );
        await _cameraController?.initialize();
        setState(() {});
      }
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isCameraPermissionGranted = true;
      });
    }
  }

  void _simulateWordDetection() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        detectedGesture = words[currentWordIndex];
        currentWordIndex = (currentWordIndex + 1) % words.length;
      });

      // Send the detected gesture to the Flask API for translation
      _getTranslation(detectedGesture);
    });
  }

  Future<void> _getTranslation(String gesture) async {
    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/translate'),  // Replace with your Flask API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'gesture': gesture}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        setState(() {
          translation = responseData['translation'];
        });
      } else {
        setState(() {
          translation = "Error fetching translation";
        });
      }
    } catch (e) {
      setState(() {
        translation = "Failed to connect to the server";
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign to Text',
          style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _isCameraPermissionGranted
                ? (_cameraController != null && _cameraController!.value.isInitialized)
                ? CameraPreview(_cameraController!)
                : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
            )
                : Center(child: Text('Camera permission not granted')),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: themeProvider.isDarkMode ? Colors.black : Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Detected Gesture: $detectedGesture',
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Translation: $translation',
                    style: TextStyle(
                      color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
