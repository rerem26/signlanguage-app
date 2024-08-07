import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(SignLanguageApp());
}

class SignLanguageApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ASL Alphabet Animation',
      home: SignLanguageHomePage(),
    );
  }
}

class SignLanguageHomePage extends StatelessWidget {
  final List<String> alphabet = List.generate(26, (index) => String.fromCharCode('A'.codeUnitAt(0) + index));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ASL Alphabet Animation'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 3,
          padding: EdgeInsets.all(16.0),
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 20.0,
          children: List.generate(alphabet.length, (index) {
            String letter = alphabet[index];
            return buildLetterButton(context, letter);
          }),
        ),
      ),
    );
  }

  Widget buildLetterButton(BuildContext context, String letter) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AnimationPage(letter: letter)),
        );
      },
      child: Container(
        width: 150,
        height: 150,
        color: Colors.teal[500],
        child: Center(
          child: Text(
            'Tap to animate "$letter"',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class AnimationPage extends StatelessWidget {
  final String letter;

  AnimationPage({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letter "$letter" Animation'),
        centerTitle: true,
        backgroundColor: Colors.teal[700],
      ),
      body: Center(
        child: HandGestureAnimation(letter: letter),
      ),
    );
  }
}

class HandGestureAnimation extends StatefulWidget {
  final String letter;

  HandGestureAnimation({required this.letter});

  @override
  _HandGestureAnimationState createState() => _HandGestureAnimationState();
}

class _HandGestureAnimationState extends State<HandGestureAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_controller.isAnimating) {
          _controller.stop();
        } else {
          _controller.repeat(reverse: true);
        }
      },
      child: AnimatedHandGesture(animation: _animation, letter: widget.letter),
    );
  }
}

class AnimatedHandGesture extends AnimatedWidget {
  final String letter;

  AnimatedHandGesture({required Animation<double> animation, required this.letter})
      : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable as Animation<double>;
    return CustomPaint(
      size: Size(100, 100),
      painter: HandGesturePainter(animation.value, letter),
    );
  }
}

class HandGesturePainter extends CustomPainter {
  final double animationValue;
  final String letter;

  HandGesturePainter(this.animationValue, this.letter);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    // Example: Draw hand gestures for each letter based on animationValue
    switch (letter) {
      case 'A':
        break;
      case 'B':
        break;
    // Add cases for other letters as needed
    // case 'C':
    //   // Draw hand gesture C based on animationValue
      default:
      // Default placeholder
      // Draw a default shape or path
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Implement your own logic for repaint
  }
}
