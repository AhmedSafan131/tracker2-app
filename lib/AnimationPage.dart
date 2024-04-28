import 'package:flutter/material.dart';
import 'package:lit_starfield/lit_starfield.dart';

import 'option.dart'; // Import the Option class

class AnimationPage extends StatefulWidget {
  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LitStarfieldContainer(
            animated: true,
            number: 500,
            velocity: 0.85,
            depth: 0.9,
            scale: 4,
            starColor: Colors.amber,
            backgroundDecoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF031936),
                  Color(0xFF141334),
                  Color(0xFF284059),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
          SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Center(
                    child: Image(
                      image: AssetImage('assets/tracker3.png'),
                    ),
                  ),
                ),
                SizedBox(
                  height: 0.1,
                ),
                Text(
                  'Hi',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '"Your safety is in our hands"',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 390,
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to the Option screen when the button is tapped
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Option()),
                    );
                  },
                  child: Container(
                    height: 50,
                    width: 330,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[600],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.blueGrey),
                    ),
                    child: Center(
                      child: Text(
                        "Let's Start",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
