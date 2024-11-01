import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

class SignText extends StatefulWidget {
  @override
  _SignTextState createState() => _SignTextState();
}

class _SignTextState extends State<SignText> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraPermissionGranted = false;
  bool _isUsingFrontCamera = true;
  String detectedGesture = "No gesture detected";
  Interpreter? _interpreter;
  List<String> labels = [];
  List<int>? _outputShape;

  @override
  void initState() {
    super.initState();
    _initializeResources();
  }

  Future<void> _initializeResources() async {
    await _requestCameraPermission();

    // Load model and labels first
    bool modelLoaded = await _loadModelAndLabels();
    if (!modelLoaded) {
      setState(() {
        detectedGesture = "Failed to load model or labels";
      });
      return;
    }

    if (_isCameraPermissionGranted) {
      await _initCamera();
    } else {
      print("Camera permission not granted.");
      setState(() {
        detectedGesture = "Camera permission not granted";
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isCameraPermissionGranted = true;
      });
    } else {
      print("Camera permission denied.");
      setState(() {
        detectedGesture = "Camera permission denied";
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        print("No cameras found.");
        setState(() {
          detectedGesture = "No cameras found";
        });
        return;
      }

      final selectedCamera = _cameras!.firstWhere(
            (camera) => camera.lensDirection == (_isUsingFrontCamera ? CameraLensDirection.front : CameraLensDirection.back),
        orElse: () => _cameras!.first,
      );

      _cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
      );

      await _cameraController!.initialize();

      _cameraController!.startImageStream((CameraImage cameraImage) async {
        if (_interpreter != null && labels.isNotEmpty && _outputShape != null) {
          await _runModelOnFrame(cameraImage);
        } else {
          print("Model or labels not initialized.");
        }
      });

      setState(() {});
    } catch (e) {
      print("Failed to initialize camera: $e");
      setState(() {
        detectedGesture = "Failed to initialize camera";
      });
    }
  }

  Future<bool> _loadModelAndLabels() async {
    try {
      print("Loading TFLite model...");
      // Check if the model asset exists
      try {
        final ByteData data = await rootBundle.load('assets/models.tflite');
        print("Model asset loaded successfully.");
      } catch (e) {
        print("Error loading model asset: $e");
        return false;
      }

      _interpreter = await Interpreter.fromAsset('models.tflite');
      _outputShape = _interpreter?.getOutputTensor(0).shape;
      if (_outputShape == null) {
        print("Error: Model output shape is null.");
        return false;
      }
      print("Model loaded with output shape: $_outputShape");

      print("Loading labels...");
      // Check if the labels asset exists
      try {
        final labelData = await rootBundle.loadString('assets/labels.txt');
        labels = labelData.split('\n').where((label) => label.isNotEmpty).toList();
        print("Labels loaded successfully.");
      } catch (e) {
        print("Error loading labels asset: $e");
        return false;
      }

      if (labels.isEmpty) {
        print("Error: Labels are empty.");
        return false;
      }

      return true;
    } catch (e) {
      print("Error loading model or labels: $e");
      return false;
    }
  }

  Future<void> _runModelOnFrame(CameraImage cameraImage) async {
    try {
      if (_interpreter == null || _outputShape == null || labels.isEmpty) {
        print("Interpreter, output shape, or labels not initialized.");
        return;
      }

      final inputImage = _convertCameraImage(cameraImage);
      var output = List.filled(_outputShape![1], 0.0).reshape(_outputShape!);

      _interpreter?.run(inputImage, output);

      int maxIndex = output[0].indexOf(output[0].reduce((a, b) => a > b ? a : b));
      setState(() {
        detectedGesture = labels[maxIndex];
      });
    } catch (e) {
      print("Error during model inference: $e");
      setState(() {
        detectedGesture = "Error during model inference";
      });
    }
  }

  Uint8List _convertCameraImage(CameraImage cameraImage) {
    final width = cameraImage.planes[0].bytesPerRow;
    final height = cameraImage.height;

    var image = img.Image.fromBytes(
      width,
      height,
      cameraImage.planes[0].bytes,
      format: img.Format.bgra,
    );

    var resizedImage = img.copyResize(image, width: 224, height: 224);
    resizedImage = img.grayscale(resizedImage);

    return Uint8List.fromList(img.encodeJpg(resizedImage));
  }

  void _switchCamera() async {
    if (_cameraController != null) {
      await _cameraController!.stopImageStream();
      await _cameraController!.dispose();
      setState(() {
        _isUsingFrontCamera = !_isUsingFrontCamera;
      });
      await _initCamera();
    }
  }

  Color _getGestureColor(String gesture) {
    switch (gesture) {
      case "Hello":
        return Colors.orange.shade100;
      case "Thank you":
        return Colors.pink.shade100;
      case "Yes":
        return Colors.purple.shade200;
      case "No":
        return Colors.blue.shade100;
      case "Good":
        return Colors.orange.shade200;
      case "I love you":
        return Colors.red.shade100;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _interpreter?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign to Text'),
        actions: [
          IconButton(
            icon: Icon(_isUsingFrontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: _switchCamera,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _isCameraPermissionGranted
                ? (_cameraController != null && _cameraController!.value.isInitialized)
                ? CameraPreview(_cameraController!)
                : Center(child: CircularProgressIndicator())
                : Center(child: Text('Camera permission not granted')),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: _getGestureColor(detectedGesture),
              child: Text(
                detectedGesture,
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
