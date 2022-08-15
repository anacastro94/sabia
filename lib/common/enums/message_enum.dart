enum MessageEnum {
  text('text'),
  gif('gif'),
  audio('audio');

  final String type;
  const MessageEnum(this.type);
}

// Extension methods https://dart.dev/guides/language/extension-methods
// Enhanced enums

extension ConvertMessage on String {
  MessageEnum toEnum() {
    switch (this) {
      case 'text':
        return MessageEnum.text;
      case 'gif':
        return MessageEnum.gif;
      case 'audio':
        return MessageEnum.audio;
      default:
        return MessageEnum.text;
    }
  }
}
