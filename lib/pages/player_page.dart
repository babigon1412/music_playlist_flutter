import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_playlist_flutter/models/songs.dart';
import 'package:music_playlist_flutter/utils/dimensions.dart';
import 'package:music_playlist_flutter/widgets/bigtext.dart';
import 'package:music_playlist_flutter/widgets/smalltext.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';

import '../seekbar/position_seek_slider.dart';

class PlayerPage extends StatefulWidget {
  const PlayerPage({Key? key, required this.player}) : super(key: key);
  final AssetsAudioPlayer player;

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = true;

  @override
  void initState() {
    widget.player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });

    widget.player.onReadyToPlay.listen((event) {
      if (mounted) {
        setState(() {
          duration = event?.duration ?? Duration.zero;
        });
      }
    });

    widget.player.currentPosition.listen((event) {
      if (mounted) {
        setState(() {
          position = event;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: Dimensions.ten * 3.5),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder<PaletteGenerator>(
            // Get color from the cover image
            future: getImageColors(widget.player),
            builder: ((context, snapshot) => Container(
                  color: snapshot.data?.mutedColor?.color,
                )),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                // shading color
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: Dimensions.screenHeight * 0.17,
            child: SizedBox(
              width: Dimensions.screenWidth * 0.8,
              // color: Colors.white,
              child: Column(
                children: [
                  // Song's name
                  BigText(
                    text: widget.player.getCurrentAudioTitle,
                    size: Dimensions.ten * 3,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Dimensions.ten * 2),
                  // Artist's name
                  SmallText(
                    text: widget.player.getCurrentAudioArtist,
                    size: Dimensions.ten * 1.6,
                  ),
                  SizedBox(height: Dimensions.ten * 5),
                  // Image
                  Container(
                    height: Dimensions.ten * 25,
                    width: Dimensions.ten * 25,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: Dimensions.ten * 2,
                          spreadRadius: 2,
                          offset: const Offset(10, 10),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      widget.player.getCurrentAudioImage?.path ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: Dimensions.ten * 8),
                  // Slider bar and times
                  widget.player.builderRealtimePlayingInfos(
                      builder: (context, RealtimePlayingInfos? infos) {
                    if (infos == null) {
                      return const SizedBox();
                    }
                    return Column(
                      children: [
                        PositionSeekWidget(
                          currentPosition: infos.currentPosition,
                          duration: infos.duration,
                          seekTo: (to) {
                            widget.player.seek(to);
                          },
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: Dimensions.ten * 2),
                  Padding(
                    padding: EdgeInsets.only(right: Dimensions.ten * 1.6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Previous button
                        IconButton(
                          onPressed: () {
                            widget.player.previous();
                          },
                          icon: Icon(
                            Icons.skip_previous_rounded,
                            size: Dimensions.ten * 5,
                            color: Colors.white70,
                          ),
                        ),
                        // Play and pause button
                        IconButton(
                          onPressed: () {
                            widget.player.playOrPause();
                          },
                          icon: isPlaying
                              ? Icon(
                                  Icons.pause_circle_filled_rounded,
                                  size: Dimensions.ten * 5,
                                  color: Colors.white70,
                                )
                              : Icon(
                                  Icons.play_circle_fill_rounded,
                                  size: Dimensions.ten * 5,
                                  color: Colors.white70,
                                ),
                        ),
                        // Next button
                        IconButton(
                          onPressed: () {
                            widget.player.next();
                          },
                          icon: Icon(
                            Icons.skip_next_rounded,
                            size: Dimensions.ten * 5,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
