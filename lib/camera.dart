import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Tflite.loadModel(
    model: 'assets/model.tflite',
    labels: 'assets/labels.txt',
  );
  final cameras = await availableCameras();

  runApp(MaterialApp(
    home: CameraApp(cameras: cameras),
  ));
}

class CameraApp extends StatefulWidget {
  final List<CameraDescription> cameras;

  CameraApp({required this.cameras});

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  int _selectedCameraIndex = 0;
  List _recognitions = [];

  @override
  void initState() {
    super.initState();
    _initCamera(_selectedCameraIndex);
  }

  void _initCamera(int index) async {
    _controller = CameraController(
      widget.cameras[index],
      ResolutionPreset.medium,
    );

    await _controller.initialize();

    if (mounted) {
      setState(() {});
    }

    _controller.startImageStream((CameraImage img) {
      if (img.format.group == ImageFormatGroup.yuv420) {
        _classifyFrame(img);
      }
    });
  }

  void _classifyFrame(CameraImage img) async {
    final ByteData allBytes = ByteData(img.width * img.height);

    int planeIndex = 0;
    for (final Plane plane in img.planes) {
      final Uint8List bytes = plane.bytes;
      for (int i = 0; i < bytes.length; i++) {
        allBytes.setUint8(planeIndex + i, bytes[i]);
      }
      planeIndex += bytes.length;
    }

    final predictions = await Tflite.runModelOnFrame(
      bytesList: [allBytes.buffer.asUint8List()],
      imageHeight: img.height,
      imageWidth: img.width,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 5,
      rotation: 90,
      threshold: 0.5,
    );

    if (predictions != null && predictions.isNotEmpty) {
      setState(() {
        _recognitions = predictions;
      });
    }
  }

  void _toggleCamera() async {
    final newIndex = _selectedCameraIndex == 0 ? 1 : 0; // Flip between cameras

    if (_controller != null) {
      await _controller.dispose(); // Dispose the current controller
    }

    _selectedCameraIndex = newIndex;
    _initCamera(newIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tracker',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        backgroundColor: Color(0xFF141436),
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon (arrow) color to white
        ),
      ),
      body: Center(
        child: Stack(
          children: [
            CameraPreview(_controller),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _toggleCamera,
                    icon: Icon(Icons.switch_camera),
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
