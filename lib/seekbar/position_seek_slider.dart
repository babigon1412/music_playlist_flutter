import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:music_playlist_flutter/utils/dimensions.dart';

class PositionSeekWidget extends StatefulWidget {
  final Duration currentPosition;
  final Duration duration;
  final Function(Duration) seekTo;

  const PositionSeekWidget({
    required this.currentPosition,
    required this.duration,
    required this.seekTo,
  });

  @override
  _PositionSeekWidgetState createState() => _PositionSeekWidgetState();
}

class _PositionSeekWidgetState extends State<PositionSeekWidget> {
  late Duration _visibleValue;
  bool listenOnlyUserInterraction = false;
  double get percent => widget.duration.inMilliseconds == 0
      ? 0
      : _visibleValue.inMilliseconds / widget.duration.inMilliseconds;

  @override
  void initState() {
    super.initState();
    _visibleValue = widget.currentPosition;
  }

  @override
  void didUpdateWidget(PositionSeekWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listenOnlyUserInterraction) {
      _visibleValue = widget.currentPosition;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          durationToString(widget.currentPosition),
          style: const TextStyle(color: Colors.white70),
        ),
        SizedBox(width: Dimensions.ten * 1.5),
        Expanded(
          child: NeumorphicSlider(
            height: Dimensions.ten * 0.6,
            min: 0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: percent * widget.duration.inMilliseconds.toDouble(),
            style:
                const SliderStyle(variant: Colors.white, accent: Colors.white),
            onChangeEnd: (newValue) {
              setState(() {
                listenOnlyUserInterraction = false;
                widget.seekTo(_visibleValue);
              });
            },
            onChangeStart: (_) {
              setState(() {
                listenOnlyUserInterraction = true;
              });
            },
            onChanged: (newValue) {
              setState(() {
                final to = Duration(milliseconds: newValue.floor());
                _visibleValue = to;
              });
            },
          ),
        ),
        SizedBox(width: Dimensions.ten * 1.5),
        Text(
          durationToString(widget.duration),
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}

String durationToString(Duration duration) {
  String twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  final twoDigitMinutes =
      twoDigits(duration.inMinutes.remainder(Duration.minutesPerHour));
  final twoDigitSeconds =
      twoDigits(duration.inSeconds.remainder(Duration.secondsPerMinute));
  return '$twoDigitMinutes:$twoDigitSeconds';
}
