import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PracticeASL(),
    );
  }
}

class PracticeASL extends StatelessWidget {
  final List<String> aslPhrases = [
    'Learn Basic Phrases in FSL',
    'Thank you',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Practice ASL',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[200]!],
          ),
        ),
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: aslPhrases.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                if (aslPhrases[index] == 'Learn Basic Phrases in FSL') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ASLVideoPlayerScreen(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ASLPracticeDetail(
                        phrase: aslPhrases[index],
                      ),
                    ),
                  );
                }
              },
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        aslPhrases[index],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.blue[800],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class ASLVideoPlayerScreen extends StatefulWidget {
  @override
  _ASLVideoPlayerScreenState createState() => _ASLVideoPlayerScreenState();
}

class _ASLVideoPlayerScreenState extends State<ASLVideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isVideoReady = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/fsl.mp4')
      ..initialize().then((_) {
        setState(() {
          _isVideoReady = true;
        });
        _controller.play();
      }).catchError((error) {
        print('Error loading video: $error');
        setState(() {
          _isError = true;
        });
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Learn Basic Phrases',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: _isError
            ? Text(
          'Error loading video. Please check the video file and path.',
          style: TextStyle(color: Colors.red, fontSize: 16),
          textAlign: TextAlign.center,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isVideoReady
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            )
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            if (_isVideoReady) ...[
              Text(
                'To sign "Basic Phrases", observe the video or image (if available) for hand shapes and movements.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Tips: Practice slowly and focus on accuracy. Signing is about clarity, not speed.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[900],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ]
          ],
        ),
      ),
      floatingActionButton: _isVideoReady
          ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _controller.value.isPlaying ? _controller.pause() : _controller.play();
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      )
          : null,
    );
  }
}

class ASLPracticeDetail extends StatelessWidget {
  final String phrase;

  ASLPracticeDetail({required this.phrase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          phrase,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.blue[200]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                phrase,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'To sign "$phrase", observe the video or image (if available) for hand shapes and movements.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Tip: Practice slowly and focus on accuracy. Signing is about clarity, not speed.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue[900],
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
