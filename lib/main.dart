import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tracker2_app/camera.dart'; // Make sure to import the camera.dart file.
import 'package:tracker2_app/option.dart';

import 'AnimationPage.dart';
import 'SplashScreenPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/SplashScreenPage_route',
    routes: {
      '/SplashScreenPage_route': (context) => SplashScreenPage(),
      '/AnimationPage_route': (context) => AnimationPage(),
      '/option_route': (context) => Option(),
      '/camera_route': (context) =>
          CameraApp(cameras: cameras), // Pass the camera parameter here.
    },
  ));
}
