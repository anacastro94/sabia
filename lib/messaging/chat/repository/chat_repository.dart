import 'dart:io';

import 'package:bbk_final_ana/common/providers/message_reply_provider.dart';
import 'package:bbk_final_ana/common/repositories/common_firestore_repository.dart';
import 'package:bbk_final_ana/models/chat_contact.dart';
import 'package:bbk_final_ana/models/group.dart';
import 'package:bbk_final_ana/models/user_model.dart';
import 'package:bbk_final_ana/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../common/enums/message_enum.dart';
import '../../../models/message.dart';

final chatRepositoryProvider = Provider((ref) => ChatRepository(
    firestore: FirebaseFirestore.instance, auth: FirebaseAuth.instance));

class ChatRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  ChatRepository({required this.firestore, required this.auth});

  Stream<List<ChatContact>> getChatContacts() {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();
        var user = UserModel.fromMap(userData.data()!);

        contacts.add(
          ChatContact(
            name: user.name,
            profilePicture: user.profilePicture,
            contactId: chatContact.contactId,
            timeSent: chatContact.timeSent,
            lastMessage: chatContact.lastMessage,
          ),
        );
      }
      return contacts;
    });
  }

  Stream<List<Group>> getChatGroups() {
    return firestore.collection('groups').snapshots().map((event) {
      List<Group> groups = [];
      for (var document in event.docs) {
        var group = Group.fromMap(document.data());
        if (group.membersUid.contains(auth.currentUser!.uid)) {
          groups.add(group);
        }
      }
      return groups;
    });
  }

  Stream<List<Message>> getChatStream(String receiverUserId) {
    return firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection('chats')
        .doc(receiverUserId)
        .collection('messages')
        .orderBy('timeSent')
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

  Stream<List<Message>> getGroupChatStream(String groupId) {
    return firestore
        .collection('groups')
        .doc(groupId)
        .collection('chats')
        .orderBy('timeSent')
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

  void _saveDataToContactsSubCollection({
    required UserModel sender,
    required UserModel? receiver,
    required String text,
    required DateTime timeSent,
    required String receiverId,
    required bool isGroupChat,
  }) async {
    if (isGroupChat) {
      await firestore.collection('groups').doc(receiverId).update({
        'lastMessage': text,
        'timeSent': DateTime.now().millisecondsSinceEpoch,
      });
    } else {
      var receiverChatContact = ChatContact(
        name: sender.name,
        profilePicture: sender.profilePicture,
        contactId: sender.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      // users -> receiverId -> chats -> currentUser.uid -> set data
      await firestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .set(
            receiverChatContact.toMap(),
          );

      var senderChatContact = ChatContact(
        name: receiver!.name,
        profilePicture: receiver.profilePicture,
        contactId: receiver.uid,
        timeSent: timeSent,
        lastMessage: text,
      );
      // users -> currentUser.id -> chats -> receiverId -> set data
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .set(
            senderChatContact.toMap(),
          );
    }
  }

  void _saveMessageToContactsSubCollection({
    required String receiverId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderName,
    required String? receiverName,
    required bool isGroupChat,
  }) async {
    final message = Message(
      senderId: auth.currentUser!.uid,
      receiverId: receiverId,
      text: text,
      type: messageType,
      timeSent: timeSent,
      messageId: messageId,
      isSeen: false,
      repliedMessage: messageReply == null ? '' : messageReply.message,
      repliedTo: messageReply == null
          ? ''
          : messageReply.isMe
              ? senderName
              : receiverName ?? '',
      repliedMessageType:
          messageReply == null ? MessageEnum.text : messageReply.messageEnum,
    );
    if (isGroupChat) {
      // groups -> groupId -> chat -> message
      await firestore
          .collection('groups')
          .doc(receiverId)
          .collection('chat')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    } else {
      // users -> receiverId -> senderId -> messages -> messageId -> store message
      await firestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set(
            message.toMap(),
          );
    }
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String receiverId,
    required UserModel sender,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiver;

      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(receiverId).get();
        receiver = UserModel.fromMap(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();
      _saveDataToContactsSubCollection(
          sender: sender,
          receiver: receiver,
          text: text,
          timeSent: timeSent,
          receiverId: receiverId,
          isGroupChat: isGroupChat);

      _saveMessageToContactsSubCollection(
          receiverId: receiverId,
          text: text,
          timeSent: timeSent,
          messageId: messageId,
          userName: sender.name,
          messageType: MessageEnum.text,
          messageReply: messageReply,
          senderName: sender.name,
          receiverName: receiver?.name,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendAudioMessage({
    required BuildContext context,
    required File audioFile,
    required String receiverId,
    required UserModel sender,
    required ProviderRef ref,
    required MessageEnum messageEnum,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String audioFileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              'chat/${messageEnum.type}/${sender.uid}/$receiverId/$messageId',
              audioFile);

      UserModel? receiver;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(receiverId).get();
        receiver = UserModel.fromMap(userDataMap.data()!);
      }

      _saveDataToContactsSubCollection(
          sender: sender,
          receiver: receiver,
          text: '🎵 Audio',
          timeSent: timeSent,
          receiverId: receiverId,
          isGroupChat: isGroupChat);

      _saveMessageToContactsSubCollection(
          receiverId: receiverId,
          text: audioFileUrl,
          timeSent: timeSent,
          messageId: messageId,
          userName: sender.name,
          messageType: messageEnum,
          messageReply: messageReply,
          senderName: sender.name,
          receiverName: receiver?.name,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGifMessage({
    required BuildContext context,
    required String gifUrl,
    required String receiverId,
    required UserModel sender,
    required MessageReply? messageReply,
    required bool isGroupChat,
  }) async {
    try {
      var timeSent = DateTime.now();
      UserModel? receiver;
      if (!isGroupChat) {
        var userDataMap =
            await firestore.collection('users').doc(receiverId).get();
        receiver = UserModel.fromMap(userDataMap.data()!);
      }
      var messageId = const Uuid().v1();

      _saveDataToContactsSubCollection(
          sender: sender,
          receiver: receiver,
          text: 'GIF',
          timeSent: timeSent,
          receiverId: receiverId,
          isGroupChat: isGroupChat);

      _saveMessageToContactsSubCollection(
          receiverId: receiverId,
          text: gifUrl,
          timeSent: timeSent,
          messageId: messageId,
          userName: sender.name,
          messageType: MessageEnum.gif,
          messageReply: messageReply,
          senderName: sender.name,
          receiverName: receiver?.name,
          isGroupChat: isGroupChat);
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String receiverId,
    required String messageId,
  }) async {
    try {
      await firestore
          .collection('users')
          .doc(auth.currentUser!.uid)
          .collection('chats')
          .doc(receiverId)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});

      await firestore
          .collection('users')
          .doc(receiverId)
          .collection('chats')
          .doc(auth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .update({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
