import 'package:flutter_riverpod/flutter_riverpod.dart';

class MessageData {
  final String id;
  final String text;
  final String kind;
  final String image;
  final String senderId;
  final DateTime time;
  final bool showTime;

  MessageData({
    required this.id,
    required this.text,
    required this.kind,
    required this.image,
    required this.senderId,
    required this.time,
    required this.showTime,
  });
}

final messageDataProvider = Provider<MessageData>((ref) {
  return MessageData(
    id: '',
    text: '',
    kind: '',
    image: '',
    senderId: '',
    time: DateTime.now(),
    showTime: true,
  );
});
