import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:takwira_app/data/user_data.dart';

class ChatData {
  final String id;
  List<UserData> users = [];
  List userId = [];
  List chat = [];

  ChatData({
    required this.id,
    required this.users,
    required this.userId,
    required this.chat,
  });
}

final chatDataProvider = Provider<ChatData>((ref) {
  List userId = [2, 3, 4];
  return ChatData(
    id: '',
    users: [],
    userId: userId,
    chat: [],
  );
});
