import 'package:flutter/foundation.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioViewModel extends ChangeNotifier {

  final player = AudioPlayer();

  bool _isPlaying = false;
  Duration _currentTime = Duration();
  Duration _totalTime = Duration(milliseconds: 1);

  bool get isPlaying => _isPlaying;

  Duration get currentTime => _currentTime;

  Duration get totalTime => _totalTime;

  Future loadData() async {

    // set the source on your player instance
    await player.setSource(AssetSource('kunfaya.mp3'));

    var stream;

    stream = player.onDurationChanged.listen((Duration d) {
      _totalTime = d;
      stream.cancel();
      player.pause();
      notifyListeners();
    });

    player.onPositionChanged.listen((Duration position) {
      print(position);
      if (position.compareTo(_totalTime) >= 0) {
        player.stop();
        _currentTime = Duration();
        _isPlaying = false;
      } else {
        _currentTime = position;
      }
      notifyListeners();
    });

    player.onPlayerStateChanged.listen((PlayerState s) {
      if (s == PlayerState.completed) {
        _isPlaying = false;
        _currentTime = Duration();
        notifyListeners();
      }
    });
  }

  Future onPlayStateChanged(bool isPlaying) async {
    if (isPlaying) {
      await player.resume();
    } else {
      await player.pause();
    }
    _isPlaying = isPlaying;
    notifyListeners();
  }

  void seek(Duration position) async {
    await player.seek(position);
  }
}
