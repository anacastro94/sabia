import 'package:bbk_final_ana/common/constants/constants.dart';
import 'package:bbk_final_ana/models/audio_metadata.dart';
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
  Future<List<AudioMetadata>> fetchInitialPlaylist();
  Future<AudioMetadata> fetchAnotherAudio();
}

class AudioRepository extends PlaylistRepository {
  AudioRepository({
    required this.auth,
    required this.firestore,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  Stream<List<AudioMetadata>> getAudioMessagesStream() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('audios')
        .snapshots()
        .map((event) {
      List<AudioMetadata> audios = [];
      for (var document in event.docs) {
        var audio = AudioMetadata.fromMap(document.data());
        audios.add(audio);
      }
      return audios;
    });
  }

  @override
  Future<List<AudioMetadata>> fetchInitialPlaylist({int length = 3}) async {
    List<AudioMetadata> playlist = await getAudioMessagesStream().first;
    return playlist.take(length).toList();
  }

  // TODO: Update from here below
  @override
  Future<AudioMetadata> fetchAnotherAudio() async {
    return _nextAudio();
  }

  int _audioIndex = 0;
  static const _maxAudioNumber = 11;
  AudioMetadata _nextAudio() {
    // TODO: Get from database
    _audioIndex = (_audioIndex % _maxAudioNumber) + 1;
    return AudioMetadata(
        id: _audioIndex.toString().padLeft(3, '0'),
        author: 'SoundHelix',
        title: 'Song $_audioIndex',
        artUrl: kArtworkUrls[_audioIndex],
        url:
            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-$_audioIndex.mp3',
        senderId: 'senderId',
        timeSent: DateTime.now());
  }
}
