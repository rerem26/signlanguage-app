import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SignText extends StatefulWidget {
  @override
  _SignTextState createState() => _SignTextState();
}

class _SignTextState extends State<SignText> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraPermissionGranted = false;
  Map<String, dynamic>? msaslClasses;
  Map<String, dynamic>? msaslSynonym;
  Map<String, dynamic>? msaslTest;
  Map<String, dynamic>? msaslTrain;
  Map<String, dynamic>? msaslVal;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadAllJsons(); // Load the JSON data when the widget is initialized
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

    // Optionally call useJsonData here or in response to a user action
    useJsonData();
  }

  void useJsonData() async {
    // Ensure that the JSON data has been loaded
    if (msaslClasses != null) {
      // Example: Getting a class name by its ID (replace 'some_class_id' with an actual key)
      String className = msaslClasses!['some_class_id'];
      print('Class Name: $className');

      // You can also use this data to update the UI, for example:
      setState(() {
        // Update some state variable to display in the UI
      });
    } else {
      print('JSON data is not loaded yet.');
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign to Text',
          style: TextStyle(color: Colors.white), // Change text color to white
        ),
        backgroundColor: Colors.blue[700], // Adjusted color from the palette
      ),
      body: _isCameraPermissionGranted
          ? (_cameraController != null && _cameraController!.value.isInitialized)
          ? CameraPreview(_cameraController!)
          : Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
        ),
      )
          : Center(child: Text('Camera permission not granted')),
    );
  }
}
