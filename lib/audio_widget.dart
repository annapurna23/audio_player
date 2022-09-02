import 'dart:ui';

import 'package:flutter/material.dart';

class AudioWidget extends StatefulWidget {
  final bool isPlaying;
  final ValueChanged<bool>? onPlayStateChanged;
  final Duration currentTime;
  ValueChanged<Duration>? onSeekBarMoved;
  final Duration totalTime;

  AudioWidget({
    Key? key,
    this.isPlaying = false,
    this.onPlayStateChanged,
    this.currentTime = Duration.zero,
    this.onSeekBarMoved,
    required this.totalTime,
  }) : super(key: key);

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  double _sliderValue = 0.0;
  bool _userIsMovingSlider = false;

  void initState() {
    super.initState();
    _sliderValue = _getSliderValue();
    _userIsMovingSlider = false;
  }

  @override
  Widget build(BuildContext context) {
    if (!_userIsMovingSlider) {
      _sliderValue = _getSliderValue();
    }

    return Container(
      height: 60,
      child: Row(
        children: [
          _buildPlayPauseButton(),
          _buildCurrentTimeLabel(),
          Expanded(
            child: _buildSeekBar(context),
          ),
          _buildTotalTimeLabel(),
          SizedBox(width: 16)
        ],
      ),
    );
  }

  Text _buildTotalTimeLabel() {
    return Text(
      _getTimeString(1.0),
    );
  }

  Text _buildCurrentTimeLabel() {
    return Text(
      _getTimeString(_sliderValue),
      style: const TextStyle(
        fontFeatures: [FontFeature.tabularFigures()],
      ),
    );
  }

  Slider _buildSeekBar(BuildContext context) {
    return Slider(
      value: _sliderValue,
      activeColor: Theme.of(context).textTheme.bodyText2!.color,
      inactiveColor: Theme.of(context).disabledColor,
      onChangeStart: (value) {
        _userIsMovingSlider = true;
      },
      onChanged: (value) {
        setState(() {
          _sliderValue = value;
        });
      },
      onChangeEnd: (value) {
        _userIsMovingSlider = false;
        if (widget.onSeekBarMoved != null) {
          final currentTime = _getDuration(value);
          widget.onSeekBarMoved!(currentTime);
        }
      },
    );
  }

  IconButton _buildPlayPauseButton() {
    return IconButton(
      icon: (widget.isPlaying)
          ? const Icon(Icons.pause)
          : const Icon(Icons.play_arrow),
      color: Colors.white,
      onPressed: () {
        if (widget.onPlayStateChanged != null) {
          widget.onPlayStateChanged!(!widget.isPlaying);
        }
      },
    );
  }

  Duration _getDuration(double sliderValue) {
    final seconds = widget.totalTime.inSeconds * sliderValue;
    return Duration(seconds: seconds.toInt());
  }

  double _getSliderValue() {
    return widget.currentTime.inMilliseconds / widget.totalTime.inMilliseconds;
  }

  _getTimeString(double sliderValue) {
    final time = _getDuration(sliderValue);

    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    final minutes =
        twoDigits(time.inMinutes.remainder(Duration.minutesPerHour));
    final seconds =
        twoDigits(time.inSeconds.remainder(Duration.secondsPerMinute));

    final hours = widget.totalTime.inHours > 0 ? '${time.inHours}:' : '';
    return "$hours$minutes:$seconds";
  }
}
