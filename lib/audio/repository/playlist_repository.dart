import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/message.dart';

final playListRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return AudioRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

//TODO: DEL
final playListRepositoryProvider2 = Provider<AudioRepository>((ref) {
  return AudioRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

abstract class PlaylistRepository {
  Future<List<Map<String, dynamic>>> fetchInitialPlaylist();
  Future<Map<String, dynamic>> fetchAnotherAudio();
}

class AudioRepository extends PlaylistRepository {
  AudioRepository({
    required this.auth,
    required this.firestore,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Stream<List<Message>> getAudioMessagesStream() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('audios')
        .snapshots()
        .map((event) {
      List<Message> messages = [];
      for (var document in event.docs) {
        var message = Message.fromMap(document.data());
        messages.add(message);
      }
      return messages;
    });
  }

  @override
  Future<List<Map<String, dynamic>>> fetchInitialPlaylist(
      {int length = 1}) async {
    List<Map<String, dynamic>> playlist = await getAudioMessagesStream()
        .take(length)
        .map((messages) => messages.map((message) {
              final audioMetadata = message.metadata;
              return {
                'id': audioMetadata!.id,
                'author': audioMetadata.author,
                'title': audioMetadata.title,
                'artUrl': audioMetadata.artUrl,
                'url': audioMetadata.url,
                'isFavorite': audioMetadata.isFavorite,
              };
            }).toList())
        .first;
    return playlist;
  }

  // TODO: Update from here below
  @override
  Future<Map<String, dynamic>> fetchAnotherAudio() async {
    return _nextAudio();
  }

  int _audioIndex = 0;
  static const _maxAudioNumber = 11;
  Map<String, dynamic> _nextAudio() {
    // TODO: Get from database
    _audioIndex = (_audioIndex % _maxAudioNumber) + 1;
    return {
      'id': _audioIndex.toString().padLeft(3, '0'),
      'title': 'Song $_audioIndex',
      'author': 'SoundHelix',
      'artUrl': kArtworkUrls[_audioIndex],
      'url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_audioIndex.mp3',
      'isFavorite': false,
    };
  }
}

class FirebasePlaylistRepository extends PlaylistRepository {
  ///Returns a list of three maps, where each map represents one song.
  ///Generally in a repository like that, you would query a web API and get
  ///JSON back, which you would then convert into a Dart map before passing
  ///it back here. Since that isn’t the main focus of this tutorial, I just
  ///returned a map directly.
  @override
  Future<List<Map<String, dynamic>>> fetchInitialPlaylist(
      // TODO: Get from database
      {int length = 3}) async {
    return List.generate(length, (index) => _nextAudio());
  }

  @override
  Future<Map<String, dynamic>> fetchAnotherAudio() async {
    return _nextAudio();
  }

  // TODO: Update this consider the actual item in the database
  int _audioIndex = 0;
  static const _maxAudioNumber = 11;
  Map<String, dynamic> _nextAudio() {
    // TODO: Get from database
    _audioIndex = (_audioIndex % _maxAudioNumber) + 1;
    return {
      'id': _audioIndex.toString().padLeft(3, '0'),
      'title': 'Song $_audioIndex',
      'author': 'SoundHelix',
      'artUrl': kArtworkUrls[_audioIndex],
      'url':
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_audioIndex.mp3',
      'isFavorite': false,
    };
  }
}
