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
  late AnimationController _controller;
  late Animation<Offset> _footerSlideAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Color?> _textColorAnimation;
  late Animation<double> _dividerScaleAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Scale animation for the logo
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Text color fade animation
    _textColorAnimation = ColorTween(begin: Colors.grey, end: Colors.black).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    // Slide animation for the footer
    _footerSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 1.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Slide animation for the main text
    _textSlideAnimation = Tween<Offset>(
      begin: Offset(0.0, 0.5),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    // Divider pulsing animation
    _dividerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animations
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(seconds: 2),
                    child: Image.asset(
                      'assets/loading2.gif',
                      width: 220,
                      height: 220,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error_outline, size: 120, color: Colors.white);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SlideTransition(
                  position: _textSlideAnimation,
                  child: AnimatedBuilder(
                    animation: _textColorAnimation,
                    builder: (context, child) {
                      return Text(
                        'Empowering Connections',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                          color: _textColorAnimation.value,
                          fontFamily: 'Times New Roman',
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
                ScaleTransition(
                  scale: _dividerScaleAnimation,
                  child: Container(
                    height: 2,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: SlideTransition(
              position: _footerSlideAnimation,
              child: Center(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(seconds: 2),
                  child: Text(
                    'Powered by Intellitech Solutions',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[700],
                      fontFamily: 'Roboto',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
