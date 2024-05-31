import 'package:flutter_riverpod/flutter_riverpod.dart';

class FieldData {
  final String id;
  final String fieldName;
  final int nbFields;
  final double price;
  final String adress;
  final double distance;
  final List<String> services;
  final String ownerId;
  final int rate;
  final String fieldDesc;
  final List<String> comments;
  final List<String> reservations;
  final List<String> reservationsCode;
  final int posts;
  final int followersCount;
  final int followingCount;
  final String bio;
  final String phone;
  final String mail;

  FieldData({
    required this.id,
    required this.fieldName,
    required this.nbFields,
    required this.price,
    required this.adress,
    required this.distance,
    required this.services,
    required this.ownerId,
    required this.rate,
    required this.fieldDesc,
    required this.comments,
    required this.reservations,
    required this.reservationsCode,
    required this.posts,
    required this.followersCount,
    required this.followingCount,
    required this.bio,
    required this.phone,
    required this.mail,
  });
}

final fieldDataProvider = Provider<FieldData>((ref) {
  String fieldName = 'Field name';
  double price = 99.999;
  String adress = 'Route Sfax Km 99';
  double distance = 99.9;
  int posts = 99;
  int followersCount = 9999;
  int followingCount = 999;
  String bio =
      'SOCCER Online Sport Games for adults and children \n gym, indoor swimming pool, 3 football fields';
  String phone = '99 999 999';
  String mail = 'fieldname@gmail.com';
  int nbFields = 9;
  String fieldDesc =
      'bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla  bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla bla ';

  return FieldData(
    id: '1',
    fieldName: fieldName,
    nbFields: nbFields,
    price: price,
    adress: adress,
    distance: distance,
    services: [],
    ownerId: '',
    rate: 0,
    fieldDesc: fieldDesc,
    comments: [],
    reservations: [],
    reservationsCode: [],
    posts: posts,
    followersCount: followersCount,
    followingCount: followingCount,
    bio: bio,
    phone: phone,
    mail: mail,
  );
});
