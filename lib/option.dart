import 'package:flutter/material.dart';

class Option extends StatelessWidget {
  const Option({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141436),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tracker',
          style: TextStyle(
            color: Colors.white, // Set text color to white
          ),
        ),
        backgroundColor: Color(0xFF141436),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Set icon (arrow) color to white
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(20.0), // Adjust the radius as needed
              child: Image.asset(
                'assets/Group12.jpg',
                // Add image-specific properties here (e.g., width, height, etc.)
              ),
            ),
            SizedBox(
              height: 330,
            ),
            Container(
              height: 50.0, // Adjust the height as needed
              width: 320.0, // Adjust the width as needed
              child: ElevatedButton(
                  onPressed: () {
                    // Trigger navigation to the camera route
                    Navigator.pushNamed(context, '/camera_route');
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.blueGrey[600]),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: Text(
                    'Open Camera',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            )

            // Other widgets for additional options
          ],
        ),
      ),
    );
  }
}
