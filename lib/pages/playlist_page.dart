import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:music_playlist_flutter/models/songs.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:music_playlist_flutter/pages/player_page.dart';
import 'package:music_playlist_flutter/utils/app_colors.dart';
import 'package:music_playlist_flutter/utils/dimensions.dart';
import 'package:music_playlist_flutter/widgets/bigtext.dart';
import 'package:music_playlist_flutter/widgets/smalltext.dart';
import 'dart:math';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({Key? key}) : super(key: key);

  @override
  State<PlaylistPage> createState() => _PlaylistPage();
}

class _PlaylistPage extends State<PlaylistPage> {
  final player = AssetsAudioPlayer();
  bool isPlaying = true;
  bool isShowing = true;
  int randomNumber = 0;
  int playlistLength = getAmountSongs();

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
      backgroundColor: const Color.fromARGB(255, 242, 246, 249),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: AppColors.greyBlack,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: Dimensions.ten * 2.2),
            child: Icon(Icons.favorite_border, color: AppColors.greyBlack),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: Dimensions.ten * 33,
                width: Dimensions.screenWidth,
                padding: EdgeInsets.only(
                  top: Dimensions.ten * 12,
                  left: Dimensions.ten * 2,
                  right: Dimensions.ten * 2,
                ),
                color: const Color.fromARGB(255, 242, 246, 249),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Playlist image cover
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(Dimensions.ten * 0.5),
                          child: Image.asset(
                            'assets/images/profile.png',
                            height: Dimensions.ten * 18,
                            width: Dimensions.ten * 14,
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Playlist name and play button
                        Container(
                          padding: EdgeInsets.only(
                            left: Dimensions.ten * 2,
                            top: Dimensions.ten * 1.2,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              BigText(
                                text: 'Blue Sunshine',
                                color: AppColors.greyBlack,
                                size: Dimensions.ten * 2.6,
                              ),
                              SizedBox(height: Dimensions.ten * 0.5),
                              SmallText(
                                text: '2022 | Popular',
                                color: AppColors.blueGrey,
                                size: Dimensions.ten * 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: Dimensions.ten * 1.5),
                              SmallText(
                                text: '1.4M Liked & Downloaded',
                                color: AppColors.blueGrey,
                                size: Dimensions.ten * 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: Dimensions.ten * 0.3),
                              SmallText(
                                text: 'Pop, R&B, Jazz',
                                color: AppColors.blueGrey,
                                size: Dimensions.ten * 1.3,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(height: Dimensions.ten * 1.5),
                              ElevatedButton(
                                onPressed: () async {
                                  // Random number to play a songs (shuffle)
                                  randomNumber = Random().nextInt(songs.length);
                                  await player
                                      .playlistPlayAtIndex(randomNumber);
                                  player.getCurrentAudioImage;
                                  player.getCurrentAudioTitle;
                                  setState(() {
                                    // if isShow's false, the padding of list will incresed
                                    isShowing = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  primary: AppColors.greyBlack,
                                  shape: const StadiumBorder(),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.shuffle,
                                        color: Colors.green[500]),
                                    SizedBox(width: Dimensions.ten),
                                    BigText(
                                        text: 'Play',
                                        color: AppColors.blueGrey,
                                        size: Dimensions.ten * 1.8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const _SeperateLine(),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.ten * 1.6),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.ten * 2),
                color: const Color.fromARGB(255, 242, 246, 249),
                child: Row(
                  children: [
                    BigText(text: 'My Playlist', color: Colors.green[500]),
                    SizedBox(width: Dimensions.ten),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.ten * 0.3),
                      child: Icon(
                        Icons.circle,
                        color: AppColors.greyBlack,
                        size: Dimensions.ten * 0.5,
                      ),
                    ),
                    SizedBox(width: Dimensions.ten),
                    Padding(
                      padding: EdgeInsets.only(top: Dimensions.ten * 0.4),
                      child: SmallText(
                        text: '$playlistLength songs',
                        size: Dimensions.ten * 1.3,
                        color: AppColors.greyBlack,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Dimensions.ten * 0.5),
              // Used listview to create the list
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: Dimensions.ten * 2),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: songs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        color: const Color.fromARGB(255, 242, 246, 249),
                        elevation: 0,
                        child: ListTile(
                          visualDensity: const VisualDensity(vertical: -4),
                          leading: SizedBox(
                            height: Dimensions.ten * 4.25,
                            width: Dimensions.ten * 4,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.ten * 0.5),
                              child: Image.asset(
                                // Image's song
                                songs[index].metas.image!.path,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: BigText(
                            // Song name
                            text: songs[index].metas.title!,
                            size: Dimensions.ten * 1.6,
                            color: AppColors.greyBlack,
                          ),
                          subtitle: SmallText(
                            // Artist name
                            text: songs[index].metas.artist!,
                            color: AppColors.blueGrey,
                          ),
                          trailing:
                              Icon(Icons.more_vert, color: AppColors.greyBlack),
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
                  ? Container(
                      height: Dimensions.ten * 0,
                      color: Colors.transparent,
                    )
                  : Container(
                      height: Dimensions.ten * 8.8,
                      color: Colors.transparent,
                    ),
            ],
          ),
          // The small player part
          // It will show up when image is loaded
          // Used position to set it at the bottom
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
                          // Shading color
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
                          // Image cover
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                                player.getCurrentAudioImage?.path ?? ''),
                          ),
                          // Song name
                          title: BigText(
                            text: player.getCurrentAudioTitle,
                            size: Dimensions.ten * 1.5,
                          ),
                          // Artist
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

// The line between playlist name and songs
class _SeperateLine extends StatelessWidget {
  const _SeperateLine({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Dimensions.ten * 0.15,
      width: Dimensions.screenWidth,
      color: Colors.grey.withOpacity(0.3),
      margin: EdgeInsets.symmetric(horizontal: Dimensions.ten * 7),
    );
  }
}
