import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:provider/provider.dart'; // Import the provider package

import 'main.dart'; // Import the main file to access the ThemeProvider

class SignText extends StatefulWidget {
  @override
  _SignTextState createState() => _SignTextState();
}

class _SignTextState extends State<SignText> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isCameraPermissionGranted = false;
  String detectedGesture = "No gesture detected";

  // Extensive list of English and Tagalog sign language words
  List<String> words = [
    // English Words
    "HELLO", "WORLD", "SIGN", "LANGUAGE", "PLEASE", "THANK YOU", "SORRY", "YES",
    "NO", "GOOD MORNING", "GOOD NIGHT", "HELP", "FAMILY", "FRIEND", "LOVE",
    "HAPPY", "SAD", "EAT", "DRINK", "WATER", "FOOD", "HOUSE", "SCHOOL",
    "WORK", "PLAY", "STOP", "GO", "COME", "WAIT", "BATHROOM", "SLEEP",
    "BOOK", "PEN", "COMPUTER", "PHONE", "MONEY", "SHOP", "STORE", "COLD",
    "HOT", "RAIN", "SUN", "WIND", "SNOW", "FIRE", "TREE", "FLOWER", "DOG",
    "CAT", "BIRD", "FISH", "CAR", "BIKE", "BUS", "TRAIN", "AIRPLANE",
    "FATHER", "MOTHER", "BROTHER", "SISTER", "BABY", "CHILD", "MAN",
    "WOMAN", "DOCTOR", "NURSE", "TEACHER", "POLICE", "FIREMAN", "LAWYER",
    "PAINTER", "DANCER", "SINGER", "MUSIC", "MOVIE", "DREAM", "READ",
    "WRITE", "TALK", "HEAR", "SEE", "SMELL", "TASTE", "TOUCH", "RUN",
    "WALK", "JUMP", "DANCE", "SIT", "STAND", "OPEN", "CLOSE", "INSIDE",
    "OUTSIDE", "LEFT", "RIGHT", "UP", "DOWN", "FAST", "SLOW", "BIG", "SMALL",
    "HUNGRY", "THIRSTY", "TIRED", "BEAUTIFUL", "UGLY", "ANGRY", "LAUGH",
    "CRY", "SING", "PLAY", "READ", "WRITE", "COUNT", "DRAW", "BUILD",
    "SWIM", "DRIVE", "FLY", "WALK", "RUN", "CLIMB", "FIGHT", "KISS",
    "HUG", "SHAKE HANDS", "WAVE", "POINT", "LISTEN", "THINK", "FEEL",
    "REMEMBER", "FORGET", "DREAM", "IMAGINE", "CREATE", "MAKE", "GIVE",
    "TAKE", "ASK", "ANSWER", "SHOUT", "WHISPER", "TALK", "SPEAK", "SILENT",
    "NOISE", "LOUD", "QUIET", "PEACE", "WAR", "SAFE", "DANGER", "FEAR",
    "BRAVE", "HERO", "VILLAIN", "WIN", "LOSE", "FIGHT", "GUN", "KNIFE",
    "BOMB", "SWORD", "SHIELD", "BATTLE", "VICTORY", "DEFEAT", "HURT",
    "BLOOD", "PAIN", "HEAL", "CURE", "SICK", "DISEASE", "MEDICINE", "DOCTOR",
    "HOSPITAL", "NURSE", "SURGERY", "BANDAGE", "BURN", "CUT", "INJURY",
    "BITE", "STING", "BREAK", "FIX", "MEND", "REPAIR", "BUILD", "CREATE",
    "GROW", "PLANT", "SEED", "FLOWER", "TREE", "FOREST", "RIVER", "LAKE",
    "SEA", "OCEAN", "MOUNTAIN", "HILL", "VALLEY", "DESERT", "JUNGLE",
    "FIELD", "FARM", "GARDEN", "PARK", "CITY", "TOWN", "VILLAGE", "HOUSE",

    // Tagalog Words
    "KAMUSTA", "MUNDO", "WIKA", "PAGSASALITA", "PAKISUYO", "SALAMAT",
    "PAUMANHIN", "OO", "HINDI", "MAGANDANG UMAGA", "MAGANDANG GABI", "TULONG",
    "PAMILYA", "KAIBIGAN", "PAG-IBIG", "MASAYA", "MALUNGKOT", "KAIN", "INOM",
    "TUBIG", "PAGKAIN", "BAHAY", "ESKWELA", "TRABAHO", "LARO", "HINTO",
    "PUNTA", "HALIKA", "MAGHINTAY", "CR", "TULOG", "LIBRO", "PANGSULAT",
    "KOMPYUTER", "TELEPONO", "PERA", "BILHIN", "TINDIHAN", "MALAMIG", "MAINIT",
    "ULAN", "ARAW", "HANGIN", "NYEBE", "APOY", "PUNO", "BULAKLAK", "ASO",
    "PUSA", "IBON", "ISDA", "KOTSE", "BIKE", "BUS", "TREN", "EROPLANO",
    "AMA", "INA", "KAPATID", "BUNSO", "BATA", "LALAKI", "BABAE", "DOKTOR",
    "NARS", "GURO", "PULIS", "BOMBERO", "ABOGADO", "PINTOR", "MANANAYAW",
    "MANG-AAWIT", "MUSIKA", "PELIKULA", "PANAGINIP", "BASA", "SULAT",
    "USAP", "DINGG", "TINGIN", "AMOY", "LASA", "HAWAK", "TAKBO", "LAKAD",
    "TALON", "SAYAW", "UPO", "TAYO", "BUKSAN", "ISARA", "LOOB", "LABAS",
    "KALIWA", "KANAN", "TAAS", "BABA", "MABILIS", "MABAGAL", "MALAKI", "MALIIT",
    "GUTOM", "UHAW", "PAGOD", "MAGANDA", "PANGIT", "GALIT", "TUMAWA",
    "UMIYAK", "KANTA", "TUGTOG", "BASA", "SULAT", "BILANG", "GUHIT",
    "GUMAWA", "LUMANGOY", "MAGMANEHO", "LUMIPAD", "MAGLAKAD", "TUMAKBO",
    "UMAKYAT", "LUMABAN", "HALIK", "YAKAP", "KAMAY", "KUMAWAY", "ITURO",
    "MAKINIG", "MAG-ISIP", "DAMA", "ALALAHANIN", "KALIMUTAN", "PANAGINIP",
    "IMAHINASYON", "LIKHAIN", "GUMAWA", "MAGBIGAY", "KUNIN", "MAGTANONG",
    "SAGUTIN", "SIGAW", "BULONG", "MAG-USAP", "SALITA", "TAHIMIK",
    "INGAY", "MALAKAS", "MAHINA", "KAPAYAPAAN", "DIGMAAN", "LIGTAS",
    "DELIKADO", "TAKOT", "MATAPANG", "BAYANI", "KONTRABIDA", "MANALO",
    "MATALO", "LUMABAN", "BARIL", "KUTSILYO", "BOMBA", "ESPADA", "KALASAG",
    "LABAN", "TAGUMPAY", "TALO", "MASAKTAN", "DUGO", "SAKIT", "GUMALING",
    "LUNAS", "MAYSAKIT", "SAKIT", "GAMOT", "DOKTOR", "OSPITAL", "NARS",
    "OPERASYON", "BANDAHE", "SUNOG", "HIWA", "SAKIT", "KAGAT", "TALIM",
    "BALING", "AYUSIN", "TAYO", "AYUSIN", "GUMAWA", "LUMAGO", "HALAMAN",
    "BINHI", "BULAKLAK", "PUNO", "GUBAT", "ILOG", "DAGAT", "BUNDOK",
    "BUROL", "LAMBAK", "DISYERTO", "GUBAT", "LUPA", "BUKID", "HARDIN",
    "PARK", "SYUDAD", "BAYAN", "NAYON", "BAHAY",
  ];

  int currentWordIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
    _simulateWordDetection(); // Simulate word detection
  }

  Future<void> _initCamera() async {
    await _requestCameraPermission();
    if (_isCameraPermissionGranted) {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
        );
        await _cameraController?.initialize();
        setState(() {});
      }
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      setState(() {
        _isCameraPermissionGranted = true;
      });
    }
  }

  void _simulateWordDetection() {
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        // Simulate the detection of words one by one
        detectedGesture = words[currentWordIndex];
        currentWordIndex = (currentWordIndex + 1) % words.length;
      });
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Access the theme provider

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign to Text',
          style: TextStyle(color: themeProvider.isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: themeProvider.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: _isCameraPermissionGranted
                ? (_cameraController != null && _cameraController!.value.isInitialized)
                ? CameraPreview(_cameraController!)
                : Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[700]!),
              ),
            )
                : Center(child: Text('Camera permission not granted')),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              color: themeProvider.isDarkMode ? Colors.black : Colors.grey[300],
              child: Text(
                '$detectedGesture',
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}