import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: CameraScreen(initialCamera: frontCamera, cameras: cameras),
  ));
}

class CameraScreen extends StatefulWidget {
  final CameraDescription initialCamera;
  final List<CameraDescription> cameras;

  const CameraScreen(
      {Key? key, required this.initialCamera, required this.cameras})
      : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late int _selectedCameraIndex;
  bool _isDetecting = false;

  @override
  void initState() {
    super.initState();
    _selectedCameraIndex =
        widget.cameras.indexWhere((camera) => camera == widget.initialCamera);
    _initializeCamera(widget.initialCamera);
    _loadModel();
  }

  void _initializeCamera(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  void _loadModel() async {
    await Tflite.loadModel(
      model: 'assets/model.tflite',
    );
    print("Model is running"); // Print when the model is loaded
  }

  void _toggleCamera() {
    setState(() {
      _selectedCameraIndex = (_selectedCameraIndex + 1) % widget.cameras.length;
      final newCamera = widget.cameras[_selectedCameraIndex];
      _initializeCamera(newCamera);
    });
  }

  void _runDrowsinessDetection(CameraImage img) async {
    if (!_isDetecting) {
      _isDetecting = true;
      print("Running drowsiness detection"); // Add this line
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: img.planes.map((plane) => plane.bytes).toList(),
        imageHeight: img.height,
        imageWidth: img.width,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 2,
        threshold: 0.1,
        asynch: true,
      );

      setState(() {
        // Update UI if necessary
      });

      _isDetecting = false;
    }
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
        title: Text('Tracker'),
      ),
      body: AspectRatio(
        aspectRatio: _controller.value.aspectRatio,
        child: CameraPreview(_controller),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _toggleCamera,
        child: Icon(Icons.switch_camera),
      ),
    );
  }
}
