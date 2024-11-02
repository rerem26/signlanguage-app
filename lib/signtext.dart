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
  List<int>? _inputShape;
  List<int>? _outputShape;
  int _frameSkipCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeResources();
  }

  Future<void> _initializeResources() async {
    await _requestCameraPermission();
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
        ResolutionPreset.low,
      );

      await _cameraController!.initialize();

      _cameraController!.startImageStream((CameraImage cameraImage) async {
        if (_interpreter != null && labels.isNotEmpty && _outputShape != null && _frameSkipCounter % 10 == 0) {
          await _runModelOnFrame(cameraImage);
        }
        _frameSkipCounter++; // Skip some frames to reduce processing load
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
      _interpreter = await Interpreter.fromAsset('models.tflite');
      _inputShape = _interpreter?.getInputTensor(0).shape;
      _outputShape = _interpreter?.getOutputTensor(0).shape;

      print("Model Input Shape: $_inputShape");
      print("Model Output Shape: $_outputShape");

      final labelData = await rootBundle.loadString('assets/labels.txt');
      labels = labelData.split('\n').where((label) => label.isNotEmpty).toList();

      return true;
    } catch (e) {
      print("Error loading model or labels: $e");
      setState(() {
        detectedGesture = "Failed to load model or labels";
      });
      return false;
    }
  }

  Future<void> _runModelOnFrame(CameraImage cameraImage) async {
    try {
      if (_interpreter == null || _outputShape == null || labels.isEmpty || _inputShape == null) {
        print("Interpreter, input/output shape, or labels not initialized.");
        return;
      }

      final inputImage = _convertCameraImage(cameraImage);

      // Reshape input to match the model's expected shape [1, 224, 224, 3]
      var inputTensor = inputImage.reshape([1, 224, 224, 3]);
      var output = List.filled(_outputShape![1], 0.0).reshape(_outputShape!);

      _interpreter?.run(inputTensor, output);

      // Ensure output[0] is a List<double> and find the maximum confidence index
      List<double> outputList = List<double>.from(output[0]);
      int maxIndex = outputList.indexWhere((e) => e == outputList.reduce((a, b) => a > b ? a : b));

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


  Float32List _convertCameraImage(CameraImage cameraImage) {
    // Convert CameraImage to RGB format using img package
    img.Image rgbImage = img.Image.fromBytes(
      cameraImage.planes[0].bytesPerRow,
      cameraImage.height,
      cameraImage.planes[0].bytes,
      format: img.Format.bgra,
    );

    // Resize the image to 224x224 and normalize to [0, 1]
    img.Image resizedImage = img.copyResize(rgbImage, width: 224, height: 224);
    Float32List input = Float32List(224 * 224 * 3);
    int index = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        int pixel = resizedImage.getPixel(x, y);
        input[index++] = img.getRed(pixel) / 255.0;
        input[index++] = img.getGreen(pixel) / 255.0;
        input[index++] = img.getBlue(pixel) / 255.0;
      }
    }

    return input;
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
      body: Stack(
        children: [
          _isCameraPermissionGranted
              ? (_cameraController != null && _cameraController!.value.isInitialized)
              ? CameraPreview(_cameraController!)
              : Center(child: CircularProgressIndicator())
              : Center(child: Text('Camera permission not granted')),
          if (detectedGesture != "No gesture detected")
            Positioned(
              top: 50,
              left: 20,
              child: Container(
                padding: EdgeInsets.all(8),
                color: Colors.white.withOpacity(0.8),
                child: Text(
                  detectedGesture,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          if (detectedGesture != "No gesture detected")
            Positioned(
              top: 100,
              left: 20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
