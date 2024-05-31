import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameData extends ChangeNotifier {
  final String id;
  final String gameName;
  final String gameOwner;
  final DateTime gameDateTime;
  final String gameTime;
  final List<Map<String, dynamic>> joinedPlayers;
  final List<Map<String, dynamic>> requestedPlayers;
  final String reservationCode;
  final String fieldId;
  final int playersNeeded;
  final int members;
  final List<double> ageGroup;
  final String gameDescription;
  final List<String> positionsNeeded;
  final int requestedCount;
  final int joinedCount;
  final int invitedCount;
  final String gameImage;
  final bool private;

  GameData({
    required this.id,
    required this.gameName,
    required this.gameOwner,
    required this.gameDateTime,
    required this.gameTime,
    required this.joinedPlayers,
    required this.requestedPlayers,
    required this.reservationCode,
    required this.fieldId,
    required this.playersNeeded,
    required this.members,
    required this.ageGroup,
    required this.gameDescription,
    required this.positionsNeeded,
    required this.requestedCount,
    required this.joinedCount,
    required this.invitedCount,
    required this.gameImage,
    required this.private,
  });
  void addPlayer(Map<String, dynamic> player) {
    joinedPlayers.add(player);
    notifyListeners();
  }
}

final gameDataProvider = ChangeNotifierProvider<GameData>((ref) {
  String gameName = 'Takwira name';
  String gameOwner = 'user';
  DateTime gameDateTime = DateTime(2024, 5, 18);
  String gameTime = '21:00';
  int playersNeeded = 14;
  int members = 11;
  List<double> ageGroup = [18, 60];
  String gamedescription = 'bla bla bla bla bla bla bla bla bla bla bla bla ';
  List<String> positionsNeeded = ['GK', 'CDM', 'CM'];
  int requestedCount = 7;
  int joinedCount = 11;
  int invitedCount = 14;
  String gameImage = 'fieldCover.png';
  bool private = true;
  List<Map<String, dynamic>> joinedPlayers = [
    {"userName": "Chams69", "name": "Chams Ben Hmouda"},
    {"userName": "Mahdi", "name": "Mahdi Nasri"},
  ];

  return GameData(
    id: '',
    gameName: gameName,
    gameOwner: gameOwner,
    gameDateTime: gameDateTime,
    gameTime: gameTime,
    joinedPlayers: joinedPlayers,
    requestedPlayers: [],
    reservationCode: '',
    fieldId: '1',
    playersNeeded: playersNeeded,
    members: members,
    ageGroup: ageGroup,
    gameDescription: gamedescription,
    positionsNeeded: positionsNeeded,
    requestedCount: requestedCount,
    joinedCount: joinedCount,
    invitedCount: invitedCount,
    gameImage: gameImage,
    private: private,
  );
});
