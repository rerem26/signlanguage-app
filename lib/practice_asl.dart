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
    'Family Signs in FSL',
    'Home Signs in FSL',
    'Drinks and Food Signs in FSL',
    'Basic Greetings in FSL',
    'Alphabet in FSL',
    '40 Conversational Words in ASL',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Practice ASL',
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
        child: ListView.builder(
          padding: EdgeInsets.all(16.0),
          itemCount: aslPhrases.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                String videoPath = '';
                if (aslPhrases[index] == 'Learn Basic Phrases in FSL') {
                  videoPath = 'assets/videos/fsl.mp4';
                } else if (aslPhrases[index] == 'Family Signs in FSL') {
                  videoPath = 'assets/videos/family.mp4';
                } else if (aslPhrases[index] == 'Home Signs in FSL') {
                  videoPath = 'assets/videos/home.mp4';
                } else if (aslPhrases[index] == 'Drinks and Food Signs in FSL') {
                  videoPath = 'assets/videos/food.mp4';
                } else if (aslPhrases[index] == 'Basic Greetings in FSL') {
                  videoPath = 'assets/videos/greetings.mp4';
                } else if (aslPhrases[index] == 'Alphabet in FSL') {
                  videoPath = 'assets/videos/alphabet.mp4';
                } else if (aslPhrases[index] == '40 Conversational Words in ASL') {
                  videoPath = 'assets/videos/beginner.mp4';
                }

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ASLVideoPlayerScreen(videoPath: videoPath),
                  ),
                );
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
  final String videoPath;

  ASLVideoPlayerScreen({required this.videoPath});

  @override
  _ASLVideoPlayerScreenState createState() => _ASLVideoPlayerScreenState();
}

class _ASLVideoPlayerScreenState extends State<ASLVideoPlayerScreen> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  double _volume = 0.5;
  bool _showVolumeSlider = false;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayer();
  }

  void _initializeVideoPlayer() {
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
        _controller.setVolume(_volume);
        _controller.play();
      }).catchError((error) {
        print("Error initializing video: $error");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading video. Please check the file path.')),
        );
      });
  }

  void _toggleVolumeSlider() {
    setState(() {
      _showVolumeSlider = !_showVolumeSlider;
    });
  }

  String _getVolumeLabel() {
    if (_volume == 0) return "Mute";
    if (_volume <= 0.3) return "Low";
    if (_volume <= 0.7) return "Medium";
    return "High";
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ASL Video',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: _isInitialized
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
            SizedBox(height: 10),
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: Colors.blue[800]!,
                backgroundColor: Colors.grey[300]!,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    _formatDuration(_controller.value.position),
                    style: TextStyle(color: Colors.black),
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(Icons.replay_10, color: Colors.blue[800]),
                    onPressed: () {
                      _controller.seekTo(_controller.value.position - Duration(seconds: 10));
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.blue[800],
                    ),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying ? _controller.pause() : _controller.play();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.forward_10, color: Colors.blue[800]),
                    onPressed: () {
                      _controller.seekTo(_controller.value.position + Duration(seconds: 10));
                    },
                  ),
                  Spacer(),
                  Text(
                    _formatDuration(_controller.value.duration),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(width: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_up, color: Colors.blue[800]),
                        onPressed: _toggleVolumeSlider,
                      ),
                      if (_showVolumeSlider)
                        Positioned(
                          top: -120,
                          child: Column(
                            children: [
                              Text(
                                _getVolumeLabel(),
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              Container(
                                height: 100,
                                width: 30,
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: RotatedBox(
                                  quarterTurns: 3,
                                  child: Slider(
                                    value: _volume,
                                    min: 0,
                                    max: 1,
                                    activeColor: Colors.blue[800],
                                    onChanged: (value) {
                                      setState(() {
                                        _volume = value;
                                        _controller.setVolume(_volume);
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
            : CircularProgressIndicator(),
      ),
    );
  }
}
