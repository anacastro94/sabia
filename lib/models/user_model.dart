class UserModel {
  final String name;
  final String uid;
  final String profilePicture;
  final bool isOnline;
  final String email;
  final List<String> groupId;

  UserModel(
      {required this.name,
      required this.uid,
      required this.profilePicture,
      required this.isOnline,
      required this.email,
      required this.groupId});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'profilePicture': profilePicture,
      'isOnline': isOnline,
      'email': email,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        name: map['name'] ?? '',
        uid: map['uid'] ?? '',
        profilePicture: map['profilePicture'] ?? '',
        isOnline: map['isOnline'] ?? false,
        email: map['email'] ?? '',
        groupId: List<String>.from(map['groupId']));
  }
}
