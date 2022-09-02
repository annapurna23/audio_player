import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'audio_viewmodel.dart';
import 'audio_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  const BodyWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Image.asset(
              'assets/arrehman.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: AudioPlayer(),
          ),
        ),
      ],
    );
  }
}

class AudioPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AudioViewModel>.reactive(
      viewModelBuilder: () => AudioViewModel(),
      onModelReady: (model) => model.loadData(),
      builder: (context, model, child) => AudioWidget(
        isPlaying: model.isPlaying,
        onPlayStateChanged: (bool isPlaying) {
          model.onPlayStateChanged(isPlaying);
        },
        currentTime: model.currentTime,
        onSeekBarMoved: (Duration newCurrentTime) {
          model.seek(newCurrentTime);
        },
        totalTime: model.totalTime,
      ),
    );
  }
}
