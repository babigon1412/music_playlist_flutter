import 'package:flutter/material.dart';
import 'package:music_playlist_flutter/utils/dimensions.dart';

class SmallText extends StatelessWidget {
  final String text;
  double size;
  Color? color;
  int maxLines;
  TextAlign textAlign;
  TextOverflow overflow;

  SmallText({
    Key? key,
    required this.text,
    this.color = Colors.white,
    this.size = 0,
    this.maxLines = 1,
    this.textAlign = TextAlign.start,
    this.overflow = TextOverflow.ellipsis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      textAlign: textAlign == TextAlign.start ? TextAlign.start : textAlign,
      maxLines: maxLines == 0 ? 1 : maxLines,
      style: TextStyle(
        color: color,
        fontSize: size == 0 ? Dimensions.ten * 1.2 : size,
        shadows: [
          Shadow(
            blurRadius: 50,
            offset: const Offset(5, 5),
            color: Colors.transparent.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
