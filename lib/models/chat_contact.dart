class ChatContact {
  final String name;
  final String profilePicture;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage;

  ChatContact({
    required this.name,
    required this.profilePicture,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePicture': profilePicture,
      'contactId': contactId,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'lastMessage': lastMessage
    };
  }

  // ChatContact.fromMap(Map<String, dynamic> map)
  //     : name = map['name'] ?? '',
  //       profilePicture = map['profilePicture'] ?? '',
  //       contactId = map['contactId'] ?? '',
  //       timeSent = DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
  //       lastMessage = map['lastMessage'] ?? '';

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      contactId: map['contactId'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
      lastMessage: map['lastMessage'] ?? '',
    );
  }
}
