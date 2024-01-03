import 'dart:developer';
import 'package:chatbot/database/chat_storage.dart';
import 'package:chatbot/model/voice.dart';
import 'package:chatbot/presentation/widgets/helper/consts.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class TextToSpeechController extends GetxController {
  var isPlaying = false.obs;
  var isStopAll = false.obs;
  var flutterTts = (FlutterTts()).obs;
  var voicesList = Rx<List<Voice>>([]);
  var voice = (Voice(name: "en-US-language", locale: "en-US")).obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    initalize();
    getVoices();
  }

  initalize() async {
    await ChatHistoryStorage.getVoice().then((value) => setVoice(value));
  }

  Future<void> stopAll() async {
    await Future.delayed(Duration.zero, () {
      flutterTts.value.stop();
      isPlaying(false);
      update();
    });
  }

  Future setVoice(Voice v) async {
    voice(v);
    update();
    log(v.toMap().toString());
    await flutterTts.value.setVoice(v.toMap());
  }

  Future getVoices() async {
    final ls = Voice.parseVoicesList(voiceListString);
    voicesList(ls);
    update();
  }

  Future changeVoiceOnList(item) async {
    isLoading(true);
    update();
    await flutterTts.value.stop();
    isPlaying(false);
    update();

    voice(item);
    update();

    setVoice(voice.value);

    flutterTts.value.speak(greeting).then((value) {
      isPlaying(true);
      update();
    });
    isLoading(false);
    update();
  }

  static const voiceListString =
      "[{name: hi-in-x-hie-local, locale: hi-IN}, {name: en-us-x-tpd-network, locale: en-US}, {name: en-in-x-ena-network, locale: en-IN}, {name: en-au-x-aub-local, locale: en-AU}, {name: en-AU-language, locale: en-AU},{name: en-US-language, locale: en-US}]";
}
