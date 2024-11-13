import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

class SignText extends StatefulWidget {
  const SignText({super.key});

  @override
  _SignTextState createState() => _SignTextState();
}

class _SignTextState extends State<SignText> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraPermissionGranted = false;
  bool _isUsingFrontCamera = true;
  String detectedGesture = "";
  Interpreter? _interpreter;
  List<String> labels = [];
  List<int>? _inputShape;
  List<int>? _outputShape;
  int _noGestureFrames = 0;
  int noGestureThreshold = 3;
  double confidenceThreshold = 0.75;
  List<String> recentGestures = [];
  final int maxGestureHistory = 5;
  final int frameSkip = 3; // Process every 3rd frame to reduce computation load
  int frameCount = 0;

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
      setState(() {
        detectedGesture = "Camera permission not granted";
      });
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isCameraPermissionGranted = status.isGranted;
      if (!status.isGranted) {
        detectedGesture = "Camera permission denied";
      }
    });
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
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
          frameCount++;
          if (frameCount % frameSkip == 0) {
            await _runModelOnFrame(cameraImage);
          }
        }
      });

      setState(() {});
    } catch (e) {
      setState(() {
        detectedGesture = "Failed to initialize camera";
      });
    }
  }

  Future<bool> _loadModelAndLabels() async {
    try {
      _interpreter = await Interpreter.fromAsset('models1.tflite');
      _inputShape = _interpreter?.getInputTensor(0).shape;
      _outputShape = _interpreter?.getOutputTensor(0).shape;

      final labelData = await rootBundle.loadString('assets/labels1.txt');
      labels = labelData.split('\n').where((label) => label.isNotEmpty).toList();

      return true;
    } catch (e) {
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
      var inputTensor = inputImage.reshape([1, 224, 224, 1]);
      var output = List.generate(5, (_) => List.filled(labels.length, 0.0)).reshape([5, labels.length]);

      _interpreter?.run(inputTensor, output);
      List<double> outputList = List<double>.from(output[0]);

      int maxIndex = outputList.indexWhere((e) => e == outputList.reduce((a, b) => a > b ? a : b));
      double maxConfidence = outputList[maxIndex];

      if (maxConfidence >= confidenceThreshold) {
        recentGestures.add(labels[maxIndex]);
        if (recentGestures.length > maxGestureHistory) {
          recentGestures.removeAt(0);
        }

        String averagedGesture = _getMostFrequentGesture(recentGestures);

        setState(() {
          detectedGesture = averagedGesture.replaceAll(RegExp(r'\d'), '').trim();
        });
        _noGestureFrames = 0;
        confidenceThreshold = 0.65; // Adaptively lower threshold on successful detection
      } else {
        _noGestureFrames++;
        confidenceThreshold = 0.75; // Raise threshold when no gestures are detected
        if (_noGestureFrames >= noGestureThreshold) {
          setState(() {
            detectedGesture = "";
          });
          recentGestures.clear();
        }
      }

      print("Output scores: $outputList");
      print("Detected gesture: ${labels[maxIndex]} with confidence $maxConfidence");

    } catch (e) {
      print("Error during model inference: $e");
      setState(() {
        detectedGesture = "Error during model inference";
      });
    }
  }

  String _getMostFrequentGesture(List<String> gestures) {
    Map<String, int> frequency = {};
    for (String gesture in gestures) {
      frequency[gesture] = (frequency[gesture] ?? 0) + 1;
    }
    return frequency.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  }

  Float32List _convertCameraImage(CameraImage cameraImage) {
    img.Image rgbImage = img.Image.fromBytes(
      cameraImage.width,
      cameraImage.height,
      cameraImage.planes[0].bytes,
      format: img.Format.bgra,
    );

    img.Image resizedImage = img.copyResize(rgbImage, width: 224, height: 224);

    Float32List input = Float32List(224 * 224);
    int index = 0;

    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        int pixel = resizedImage.getPixel(x, y);
        double gray = (img.getRed(pixel) + img.getGreen(pixel) + img.getBlue(pixel)) / 3.0 / 255.0;
        input[index++] = gray;
      }
    }

    return input;
  }

  void _switchCamera() async {
    if (_cameraController != null) {
      await _cameraController!.stopImageStream();
      await _cameraController!.dispose();
      _cameraController = null;
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
        title: const Text('Sign to Text'),
        actions: [
          IconButton(
            icon: Icon(_isUsingFrontCamera ? Icons.camera_front : Icons.camera_rear),
            onPressed: _switchCamera,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: 100,
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              detectedGesture.isNotEmpty ? detectedGesture : "",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                _isCameraPermissionGranted
                    ? (_cameraController != null && _cameraController!.value.isInitialized)
                    ? CameraPreview(_cameraController!)
                    : const Center(child: CircularProgressIndicator())
                    : const Center(child: Text('Camera permission not granted')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
