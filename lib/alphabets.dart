import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const SignLanguageApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class SignLanguageApp extends StatelessWidget {
  const SignLanguageApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      title: 'Sign Language App',
      theme: ThemeData(
        brightness: themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primarySwatch: Colors.grey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        appBarTheme: AppBarTheme(
          color: themeProvider.isDarkMode ? Colors.black : Colors.white,
          iconTheme: IconThemeData(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
          ),
          titleTextStyle: TextStyle(
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.grey,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const Alphabets(),
    );
  }
}

class Alphabets extends StatelessWidget {
  const Alphabets({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Learn Signs',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[800],
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 2.0,
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ModuleCard(
                title: 'Finger Spelling',
                description: 'Learn alphabets and numbers with hand shapes.',
                icon: Icons.back_hand_outlined,
                color: Colors.blue[600]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlphabetGridScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ModuleCard(
                title: 'Basics',
                description: 'Start with basic hand signs.',
                icon: Icons.school_outlined,
                color: Colors.green[600]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BasicsScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ModuleCard(
                title: 'Intermediates',
                description: 'Explore more advanced lessons.',
                icon: Icons.language,
                color: Colors.purple[600]!,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const IntermediatesScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ModuleCard({super.key, 
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: color.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlphabetGridScreen extends StatelessWidget {
  const AlphabetGridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const totalItems = 36; // Only numbers (0-9) and uppercase letters (A-Z)

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finger Spelling'),
        backgroundColor: Colors.blue[800],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        itemCount: totalItems,
        itemBuilder: (context, index) {
          String imagePath;
          String displayText;
          String tutorialText;

          if (index < 10) {
            // Numbers (0-9)
            imagePath = 'assets/letters/$index.png';
            displayText = 'Number $index';
            tutorialText = 'For the number $index, hold up $index finger(s) on one hand.';
          } else {
            // Uppercase letters (A-Z)
            String letter = String.fromCharCode(65 + (index - 10));
            imagePath = 'assets/$letter.png';
            displayText = 'Letter $letter';
            tutorialText = 'For letter $letter, use the handshape shown, forming the shape of "$letter".';
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlphabetDetailScreen(
                    imagePath: imagePath,
                    description: displayText,
                    tutorial: tutorialText,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Image not found',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      displayText,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BasicsScreen extends StatelessWidget {
  const BasicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> basicsContent = [
      {
        'imagePath': 'assets/Hello.png',
        'description': 'Hello',
        'tutorial': 'Hand position is sideway same as military, Flat hand, fingertips at forehead, moves foreword slightly right or place tip of H hand at side of forehead then move out and form an O hand.',
      },
      {
        'imagePath': 'assets/Hi.png',
        'description': 'Hi',
        'tutorial': 'Place tip of right H hand at the side of forehead then move out and form L handshape.',
      },
      {
        'imagePath': 'assets/GoodMorning.png',
        'description': 'Good Morning',
        'tutorial': 'Palm in fingers on chin, fingers together, drop to palm of left hand as left hand rests in crook of right elbow, right palm-up hand rises to hand and twists to palm out.',
      },
      {
        'imagePath': 'assets/GoodAfternoon.png',
        'description': 'Good Afternoon',
        'tutorial': 'Palm in fingers on chin, fingers together, drop to palm of left hand as flat hand, arm resting on the back of left hand, drops forward.',
      },
      {
        'imagePath': 'assets/GoodNight.png',
        'description': 'Good Night',
        'tutorial': 'Palm in fingers on chin, fingers together, drop to palm of left hand as drop bent hand over edge of left.',
      },
      {
        'imagePath': 'assets/GoodNoon.png',
        'description': 'Good Noon',
        'tutorial': 'Palm in fingers on chin, fingers together, drop to palm of left hand as Place the right elbow, slightly palm in, on left palm down.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Basics'),
        backgroundColor: Colors.blue[800],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        itemCount: basicsContent.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BasicsDetailScreen(
                    imagePath: basicsContent[index]['imagePath']!,
                    description: basicsContent[index]['description']!,
                    tutorial: basicsContent[index]['tutorial']!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          basicsContent[index]['imagePath']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Image not found',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      basicsContent[index]['description']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BasicsDetailScreen extends StatelessWidget {
  final String imagePath;
  final String description;
  final String tutorial;

  const BasicsDetailScreen({super.key, required this.imagePath, required this.description, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          description,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Image not found\n$imagePath',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tutorial,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Tips: Practice each phrase slowly. Focus on hand position and movements as shown.',
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

class IntermediatesScreen extends StatelessWidget {
  const IntermediatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> intermediatesContent = [
      {
        'imagePath': 'assets/name.png',
        'description': 'Name',
        'tutorial': 'Place right H hand on left H hand and tap at once.',
      },
      {
        'imagePath': 'assets/surname.png',
        'description': 'Surname',
        'tutorial': 'Execute the sign for last then sign for name.',
      },
      {
        'imagePath': 'assets/familyname.png',
        'description': 'Family Name',
        'tutorial': 'Execute sign for family then the sign for name.',
      },
      {
        'imagePath': 'assets/nickname.png',
        'description': 'Nickname',
        'tutorial': 'Execute sign for call then sign for name.',
      },
      {
        'imagePath': 'assets/shortname.png',
        'description': 'Short Name',
        'tutorial': 'Right H hand brushes over left H then right H taps the left H twice.',
      },
      {
        'imagePath': 'assets/age.png',
        'description': 'Age',
        'tutorial': 'Right X hand touches the nose and is drawn downward.',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intermediates'),
        backgroundColor: Colors.blue[800],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.8,
        ),
        itemCount: intermediatesContent.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => IntermediatesDetailScreen(
                    imagePath: intermediatesContent[index]['imagePath']!,
                    description: intermediatesContent[index]['description']!,
                    tutorial: intermediatesContent[index]['tutorial']!,
                  ),
                ),
              );
            },
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          intermediatesContent[index]['imagePath']!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Text(
                                'Image not found',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      intermediatesContent[index]['description']!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue[800],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class IntermediatesDetailScreen extends StatelessWidget {
  final String imagePath;
  final String description;
  final String tutorial;

  const IntermediatesDetailScreen({super.key, required this.imagePath, required this.description, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          description,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Image not found\n$imagePath',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tutorial,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Tips: Practice each phrase slowly. Focus on hand position and movements as shown.',
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

class AlphabetDetailScreen extends StatelessWidget {
  final String imagePath;
  final String description;
  final String tutorial;

  const AlphabetDetailScreen({super.key, required this.imagePath, required this.description, required this.tutorial});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          description,
          style: const TextStyle(fontWeight: FontWeight.bold),
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
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Text(
                        'Image not found\n$imagePath',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                description,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                tutorial,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Tips: Practice each letter slowly. Focus on hand position and movements as shown.',
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

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Text('$title Content Coming Soon'),
      ),
    );
  }
}
