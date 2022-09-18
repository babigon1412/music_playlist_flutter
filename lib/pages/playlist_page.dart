import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_playlist_flutter/models/songs.dart';
import 'package:music_playlist_flutter/pages/player_page.dart';
import 'package:music_playlist_flutter/utils/dimensions.dart';
import 'package:music_playlist_flutter/widgets/bigtext.dart';
import 'package:music_playlist_flutter/widgets/smalltext.dart';
import 'package:palette_generator/palette_generator.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPage();
}

class _PlaylistPage extends State<PlaylistPage> {
  final player = AssetsAudioPlayer();
  bool isPlaying = true;
  bool isShowing = true;
  int playlistLength = getAmountSongs();
  Color textColor = Colors.white;

  @override
  void initState() {
    openPlayer();

    player.isPlaying.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = event;
        });
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void openPlayer() async {
    await player.open(Playlist(audios: songs),
        autoStart: false, showNotification: true, loopMode: LoopMode.playlist);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back_ios_new_rounded),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.ten * 2.2),
            child: const Icon(Icons.grid_view_rounded),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Dimensions.ten * 35,
                width: Dimensions.screenWidth,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('assets/images/profile.png', fit: BoxFit.cover),
                    const _ShaderImage(),
                    const _CurrentSongName(),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.ten * 2),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.ten * 1.5),
                child: Row(
                  children: [
                    BigText(text: 'My Playlist', color: Colors.green[500]),
                    SizedBox(width: Dimensions.ten),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.ten * 0.3),
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: Dimensions.ten * 0.5,
                      ),
                    ),
                    SizedBox(width: Dimensions.ten),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.ten * 0.4),
                      child: SmallText(
                        text: '$playlistLength songs',
                        size: Dimensions.ten * 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.ten * 0.5),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.ten * 2),
                  height: Dimensions.ten * 35,
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: Colors.grey[900],
                        elevation: 0,
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          leading: Padding(
                            padding: EdgeInsets.only(top: Dimensions.ten),
                            child: SmallText(text: '${index + 1}'),
                          ),
                          title: BigText(
                            text: songs[index].metas.title!,
                            size: Dimensions.ten * 1.6,
                          ),
                          subtitle: SmallText(text: songs[index].metas.artist!),
                          trailing:
                              const Icon(Icons.more_vert, color: Colors.white),
                          onTap: () async {
                            await player.playlistPlayAtIndex(index);
                            player.getCurrentAudioImage;
                            player.getCurrentAudioTitle;
                            setState(() {
                              isShowing = false;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
              isShowing
                  ? Container(height: Dimensions.ten * 1)
                  : Container(height: Dimensions.ten * 10),
            ],
          ),
          player.getCurrentAudioImage == null
              ? const SizedBox.shrink()
              : Positioned(
                  top: Dimensions.screenHeight * 0.84,
                  left: 0,
                  right: 0,
                  child: FutureBuilder<PaletteGenerator>(
                    future: getImageColors(player),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      return Container(
                        height: Dimensions.ten * 7.5,
                        margin: EdgeInsets.symmetric(
                          vertical: Dimensions.ten * 5,
                          horizontal: Dimensions.ten * 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: const Alignment(0, 5),
                            colors: [
                              snapshot.data?.lightMutedColor?.color ??
                                  Colors.grey,
                              snapshot.data?.mutedColor?.color ?? Colors.grey,
                            ],
                          ),
                          borderRadius:
                              BorderRadius.circular(Dimensions.ten * 2),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                player.getCurrentAudioImage?.path ?? ''),
                          ),
                          title: BigText(
                            text: player.getCurrentAudioTitle,
                            size: Dimensions.ten * 1.5,
                          ),
                          subtitle:
                              SmallText(text: player.getCurrentAudioArtist),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white.withOpacity(0.1),
                                child: IconButton(
                                  onPressed: () {
                                    player.playOrPause();
                                  },
                                  icon: isPlaying
                                      ? const Icon(
                                          Icons.pause_rounded,
                                          color: Colors.white,
                                        )
                                      : const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                              SizedBox(width: Dimensions.ten),
                              CircleAvatar(
                                backgroundColor: Colors.white10,
                                child: IconButton(
                                  onPressed: () {
                                    player.stop();
                                    setState(() {
                                      isShowing = true;
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.close_rounded,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                CupertinoPageRoute(
                                    fullscreenDialog: true,
                                    builder: (context) => PlayerPage(
                                          player: player,
                                        )));
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}

class _CurrentSongName extends StatelessWidget {
  const _CurrentSongName({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: Dimensions.ten * 28,
        left: Dimensions.ten * 1.5,
        right: Dimensions.ten * 1.5,
        bottom: Dimensions.ten * 1.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BigText(
            text: 'Blue Sunshine',
            color: Colors.white.withOpacity(0.8),
            size: Dimensions.ten * 3,
          ),
          const Icon(Icons.favorite, color: Colors.redAccent),
        ],
      ),
    );
  }
}

class _ShaderImage extends StatelessWidget {
  const _ShaderImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: ((rect) {
        return LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.white.withOpacity(0.5),
              Colors.white.withOpacity(0.0),
            ],
            stops: const [
              0.0,
              0.0,
              0.8,
            ]).createShader(rect);
      }),
      blendMode: BlendMode.dstOut,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.grey.shade900,
            ],
          ),
        ),
      ),
    );
  }
}
