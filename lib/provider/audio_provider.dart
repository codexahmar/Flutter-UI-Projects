import 'dart:async';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

enum PlayerMode { allahNames, none }

class AudioProvider extends ChangeNotifier with WidgetsBindingObserver {
  final AudioPlayer _player = AudioPlayer();
  PlayerMode _mode = PlayerMode.none;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  AudioPlayer get player => _player;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAllahNamesPlaying => _mode == PlayerMode.allahNames;
  PlayerMode get mode => _mode;

  StreamSubscription? _playerStateSubscription;

  AudioProvider() {
    WidgetsBinding.instance.addObserver(this);

    _playerStateSubscription = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (_mode == PlayerMode.allahNames) {
          _mode = PlayerMode.none;
        }
      }
      notifyListeners();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _playerStateSubscription?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> playAllahNames(BuildContext context, {double startSeconds = 0}) async {
    try {
      await _player.stop();

      _isLoading = true;
      _errorMessage = null;
      _mode = PlayerMode.allahNames;
      notifyListeners();

      await _player.setAudioSource(
        AudioSource.asset(
          'assets/audio/names.mp3',
          tag: MediaItem(
            id: 'allah_names_audio',
            album: "Islam Plus",
            title: "Asma-ul-husna",
          ),
        ),
      );

      _isLoading = false;
      notifyListeners();

      if (startSeconds > 0) {
        await _player.seek(Duration(milliseconds: (startSeconds * 1000).toInt()));
      }
      await _player.play();
    } catch (e) {
      _isLoading = false;
      _errorMessage = "Error playing audio";
      notifyListeners();
    }
  }

  Future<void> togglePlayback() async {
    if (_player.playing) {
      await _player.pause();
    } else {
      await _player.play();
    }
    notifyListeners();
  }

  Future<void> stop() async {
    try {
      await _player.stop();
    } catch (e) {
      debugPrint('Error stopping player: $e');
    }
    _mode = PlayerMode.none;
    notifyListeners();
  }
}
