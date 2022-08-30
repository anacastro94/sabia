class AudioMetadata {
  final String id;
  final String author;
  final String title;
  final String artUrl;
  final String url;
  final bool isFavorite;
  final bool isSeen;
  final String senderId;
  final DateTime timeSent;

  AudioMetadata({
    required this.id,
    required this.author,
    required this.title,
    required this.artUrl,
    required this.url,
    this.isFavorite = false,
    this.isSeen = false,
    required this.senderId,
    required this.timeSent,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'artUrl': artUrl,
      'url': url,
      'isFavorite': isFavorite,
      'isSeen': isSeen,
      'senderId': senderId,
      'timeSent': timeSent.millisecondsSinceEpoch,
    };
  }

  factory AudioMetadata.fromMap(Map<String, dynamic> map) {
    return AudioMetadata(
      id: map['id'] ?? '',
      author: map['author'] ?? '',
      title: map['title'] ?? '',
      artUrl: map['artUrl'] ?? '',
      url: map['url'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      isSeen: map['isSeen'] ?? false,
      senderId: map['senderId'] ?? '',
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent']),
    );
  }
}
