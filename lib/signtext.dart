import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class SignText extends StatefulWidget {
  @override
  _SignTextState createState() => _SignTextState();
}

class _SignTextState extends State<SignText> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
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
          : Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!))) // Use non-nullable color
          : Center(child: Text('Camera permission not granted')),
    );
  }
}
