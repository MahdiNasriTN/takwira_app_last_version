import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamData extends ChangeNotifier {
  final String id;
  final String teamName;
  final String teamLeader;
  final List<Map<String, dynamic>> joinedPlayers;
  final List<Map<String, dynamic>> requestedPlayers;
  final String groupId;
  final Color teamColor;
  final String formation;
  final String teamDescription;
  final int playersNeeded;
  final int members;
  final List<double> ageGroup;
  final List<String> positionsNeeded;
  final int requestedCount;
  final int joinedCount;
  final int invitedCount;
  final String teamImage;
  final bool private;

  TeamData({
    required this.id,
    required this.teamName,
    required this.teamLeader,
    required this.joinedPlayers,
    required this.requestedPlayers,
    required this.groupId,
    required this.teamColor,
    required this.formation,
    required this.teamDescription,
    required this.playersNeeded,
    required this.members,
    required this.ageGroup,
    required this.positionsNeeded,
    required this.requestedCount,
    required this.joinedCount,
    required this.invitedCount,
    required this.teamImage,
    required this.private,
  });
  void addPlayer(Map<String, dynamic> player) {
    joinedPlayers.add(player);
    notifyListeners();
  }
}

final teamDataProvider = ChangeNotifierProvider<TeamData>((ref) {
  String teamName = 'Team name';
  String teamDescription = 'We\'re looking for an apponent to play against us';
  int playersNeeded = 7;
  int members = 5;
  List<double> ageGroup = [18, 60];
  List<String> positionsNeeded = ['RB', 'CAM', 'LW'];
  String teamLeader = 'user';
  int requestedCount = 4;
  int joinedCount = 5;
  int invitedCount = 7;
  String teamImage = 'fieldCover.png';
  bool private = true;

  return TeamData(
    id: '',
    teamName: teamName,
    teamLeader: teamLeader,
    joinedPlayers: [],
    requestedPlayers: [],
    groupId: '',
    teamColor: Colors.green,
    formation: '',
    teamDescription: teamDescription,
    playersNeeded: playersNeeded,
    members: members,
    ageGroup: ageGroup,
    positionsNeeded: positionsNeeded,
    requestedCount: requestedCount,
    joinedCount: joinedCount,
    invitedCount: invitedCount,
    teamImage: teamImage,
    private: private,
  );
});
