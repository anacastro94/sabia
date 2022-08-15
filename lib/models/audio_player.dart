import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

class AudioPlayer extends ChangeNotifier {
  FlutterSoundPlayer? _player;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;
  bool get isPlaying => _player!.isPlaying;
  bool get isPaused => _player!.isPaused;
  bool get isStopped => _player!.isStopped;
  Stream? get onProgress => _player!.onProgress;


  AudioPlayer.create() {
    _player = FlutterSoundPlayer();
    init();
  }

  void init() {
    _player!.openPlayer().then((_) async {
      await _player!.setSubscriptionDuration(const Duration(milliseconds: 10));
      _isInitialized = true;
      notifyListeners();
    });
  }

  void close() {
    _player!.closePlayer();
    _player = null;
    _isInitialized = false;
    notifyListeners();
  }

  void play(String audioPath) async {
    if (!_isInitialized) throw 'Player not initialized.';
    try {
      await _player!
          .startPlayer(
            fromURI: audioPath,
            whenFinished: () {
              notifyListeners();
            },
          )
          .then((_) => notifyListeners());
    } catch (e) {
      throw e.toString();
    }
    //TODO: I might need to cancel and start again the subscription every time I play.
  }

  void stop() async {
    if (!_isInitialized) throw 'Player not initialized.';
    await _player!.stopPlayer().then((_) => notifyListeners());
  }

  void pause() async {
    if (!_isInitialized) throw 'Player not initialized.';
    if (!isPlaying) {
      return; //To avoid requesting a player to pause when it is not playing
    }
    await _player!.pausePlayer().then((_) => notifyListeners());
  }
}
