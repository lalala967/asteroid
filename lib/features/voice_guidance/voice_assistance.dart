import 'package:flutter_tts/flutter_tts.dart';

class VoiceAssistance {
  static Future<void> speak(String text, String lang) async {
    FlutterTts flutterTts = FlutterTts();
    if (text.isNotEmpty) {
      await flutterTts.setLanguage(lang);

      await flutterTts.setPitch(1.0);
      await flutterTts.setSpeechRate(0.5);
      await flutterTts.speak(text);
    }
  }
}
