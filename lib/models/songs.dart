import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

List<Audio> songs = [
  Audio(
    'assets/songs/track1.mp3',
    metas: Metas(
      title: 'Losing You',
      artist: 'Christian Kuria',
      image: const MetasImage.asset('assets/images/img1.png'),
    ),
  ),
  Audio(
    'assets/songs/track2.mp3',
    metas: Metas(
      title: 'I\'ll Get Over You',
      artist: 'Loving Caliber',
      image: const MetasImage.asset('assets/images/img2.png'),
    ),
  ),
  Audio(
    'assets/songs/track3.mp3',
    metas: Metas(
      title: 'Without A Hook',
      artist: 'Karlo & Alyssa',
      image: const MetasImage.asset('assets/images/img3.png'),
    ),
  ),
  Audio(
    'assets/songs/track4.mp3',
    metas: Metas(
      title: 'Blue',
      artist: 'Kojikoji',
      image: const MetasImage.asset('assets/images/img4.png'),
    ),
  ),
  Audio(
    'assets/songs/track5.mp3',
    metas: Metas(
      title: 'Dance With My Phone',
      artist: 'HYBS',
      image: const MetasImage.asset('assets/images/img5.png'),
    ),
  ),
  Audio(
    'assets/songs/track6.mp3',
    metas: Metas(
      title: 'Wake Me Up When September Ends',
      artist: 'Green Day',
      image: const MetasImage.asset('assets/images/img6.png'),
    ),
  ),
  Audio(
    'assets/songs/track7.mp3',
    metas: Metas(
      title: 'Love Again',
      artist: 'Meltt',
      image: const MetasImage.asset('assets/images/img7.png'),
    ),
  ),
  Audio(
    'assets/songs/track8.mp3',
    metas: Metas(
      title: 'If I Ain\'t Got You',
      artist: 'Martin Novales',
      image: const MetasImage.asset('assets/images/img8.png'),
    ),
  ),
  Audio(
    'assets/songs/track9.mp3',
    metas: Metas(
      title: 'Night Shift',
      artist: 'Frannk whitte',
      image: const MetasImage.asset('assets/images/img9.png'),
    ),
  ),
  Audio(
    'assets/songs/track10.mp3',
    metas: Metas(
      title: 'champagne',
      artist: 'Oasis',
      image: const MetasImage.asset('assets/images/img10.png'),
    ),
  ),
  Audio(
    'assets/songs/track11.mp3',
    metas: Metas(
      title: 'Pool Side',
      artist: 'Mood Inc',
      image: const MetasImage.asset('assets/images/img11.png'),
    ),
  ),
  Audio(
    'assets/songs/track12.mp3',
    metas: Metas(
      title: 'Rainy Days',
      artist: 'Alf Wardhana',
      image: const MetasImage.asset('assets/images/img12.png'),
    ),
  ),
  Audio(
    'assets/songs/track13.mp3',
    metas: Metas(
      title: 'Being Again',
      artist: 'Taylor Swift',
      image: const MetasImage.asset('assets/images/img13.png'),
    ),
  ),
  Audio(
    'assets/songs/track14.mp3',
    metas: Metas(
      title: 'Too Good',
      artist: 'Christian Kuria',
      image: const MetasImage.asset('assets/images/img14.png'),
    ),
  ),
  Audio(
    'assets/songs/track15.mp3',
    metas: Metas(
      title: '好きだから',
      artist: 'ユイカ',
      image: const MetasImage.asset('assets/images/img15.png'),
    ),
  ),
];

String durationFormat(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitsMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitsSeconds = twoDigits(duration.inSeconds.remainder(60));

  return '$twoDigitsMinutes:$twoDigitsSeconds';
}

Future<PaletteGenerator> getImageColors(AssetsAudioPlayer player) async {
  var paletteGenerator = await PaletteGenerator.fromImageProvider(
    AssetImage(player.getCurrentAudioImage?.path ?? ''),
  );

  return paletteGenerator;
}

int getAmountSongs() => songs.length;
