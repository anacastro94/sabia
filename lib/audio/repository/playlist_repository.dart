import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final playListRepositoryProvider =
    Provider<PlaylistRepository>((ref) => FirebasePlaylistRepository());

abstract class PlaylistRepository {
  Future<List<Map<String, String>>> fetchInitialPlaylist();
  Future<Map<String, String>> fetchAnotherAudio();
}

class FirebasePlaylistRepository extends PlaylistRepository {
  ///Returns a list of three maps, where each map represents one song.
  ///Generally in a repository like that, you would query a web API and get
  ///JSON back, which you would then convert into a Dart map before passing
  ///it back here. Since that isn’t the main focus of this tutorial, I just
  ///returned a map directly.
  @override
  Future<List<Map<String, String>>> fetchInitialPlaylist(
      // TODO: Get from database
      {int length = 3}) async {
    return List.generate(length, (index) => _nextAudio());
  }

  @override
  Future<Map<String, String>> fetchAnotherAudio() async {
    return _nextAudio();
  }

  // TODO: Update this consider the actual item in the database
  int _audioIndex = 0;
  static const _maxAudioNumber = 11;
  Map<String, String> _nextAudio() {
    // TODO: Get from database
    _audioIndex = (_audioIndex % _maxAudioNumber) + 1;
    return {
      'id': _audioIndex.toString().padLeft(3, '0'),
      'title': 'Song $_audioIndex',
      'author': 'SoundHelix',
      'artUrl': kArtworkUrls[_audioIndex],
      'url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_audioIndex.mp3',
    };
  }
}
