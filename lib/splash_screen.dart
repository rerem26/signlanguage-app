import 'package:flutter/material.dart';
import 'dart:async';
import 'main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  final int splashDuration = 4;
  double _opacity = 0.0;
  final double _dividerWidth = 50.0;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for scaling and divider animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Start the fade-in animation
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
      _controller.forward();
    });

    // Navigate to the next screen after the splash duration
    Timer(Duration(seconds: splashDuration), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => SignLanguageHomePage(),
      ));
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller to avoid memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Corporate color background
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(seconds: 5),
              child: Image.asset(
                'assets/loading2.gif',
                width: 220,
                height: 220,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error_outline, size: 120, color: Colors.white);
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Empowering Connections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w300,
                color: Colors.black,
                fontFamily: 'Times New Roman', // Use a clean, modern font
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Container(
                  height: 2,
                  width: _controller.value * MediaQuery.of(context).size.width,
                  color: Colors.black,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
