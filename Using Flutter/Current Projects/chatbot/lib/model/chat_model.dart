class ChatModel {
  late String text;
  late String img;
  late bool isMe;

  ChatModel({required this.text, required this.isMe, required this.img});

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      text: map['text'],
      isMe: map['isMe'] == 1,
      img: map['img'],
    );
  }

  // Convert Chat object to a Map
  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'img': img,
      'isMe': isMe ? '1' : '0',
    };
  }
}
