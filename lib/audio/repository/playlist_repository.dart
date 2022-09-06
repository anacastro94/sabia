import 'package:bbk_final_ana/models/audio_metadata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../utils/utils.dart';

final playListRepositoryProvider = Provider<PlaylistRepository>((ref) {
  return AudioRepository(
    auth: FirebaseAuth.instance,
    firestore: FirebaseFirestore.instance,
  );
});

abstract class PlaylistRepository {
  Future<List<AudioMetadata>> fetchInitialPlaylist();
  void toggleAudioMessageFavorite({
    required BuildContext context,
    required String senderId,
    required String messageId,
  });
  void setAudioMessageSeen({
    required BuildContext context,
    required String senderId,
    required String messageId,
  });
  Stream<List<AudioMetadata>> getAudioMessagesStream();
}

class AudioRepository extends PlaylistRepository {
  AudioRepository({
    required this.auth,
    required this.firestore,
  });
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  @override
  Stream<List<AudioMetadata>> getAudioMessagesStream() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('audios')
        .orderBy('timeSent', descending: true)
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
  Future<List<AudioMetadata>> fetchInitialPlaylist() async {
    List<AudioMetadata> playlist = await getAudioMessagesStream().first;
    return playlist.toList();
  }

  /// Function to toggle the isFavorite of the audio message.
  /// Only the current user as receiver of the message can toggle.
  /// Still, the message will be update for the sender and receiver.
  @override
  void toggleAudioMessageFavorite({
    required BuildContext context,
    required String senderId,
    required String messageId,
  }) async {
    try {
      final audioData = await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('audios')
          .doc(messageId)
          .get();
      final audio = AudioMetadata.fromMap(audioData.data()!);
      final isFavorite = audio.isFavorite;
      void updateAudioInFirestore(String userId, bool isFavorite) async =>
          await firestore
              .collection('users')
              .doc(userId)
              .collection('audios')
              .doc(messageId)
              .update({'isFavorite': isFavorite});

      if (isFavorite) {
        // Update in the audio for the receiver (current user)
        updateAudioInFirestore(auth.currentUser!.uid, false);

        // Update in the audio for the sender
        updateAudioInFirestore(senderId, false);
      } else {
        // Update in the audio for the receiver (current user)
        updateAudioInFirestore(auth.currentUser!.uid, true);

        // Update in the audio for the sender
        updateAudioInFirestore(senderId, false);
      }
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  @override
  void setAudioMessageSeen({
    required BuildContext context,
    required String senderId,
    required String messageId,
  }) async {
    try {
      // Update current user database
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('audios')
          .doc(messageId)
          .update({'isSeen': true});

      // Update sender database
      await firestore
          .collection('users')
          .doc(senderId)
          .collection('audios')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
