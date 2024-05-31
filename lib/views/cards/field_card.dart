import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/data/field_data.dart';
import 'package:takwira_app/providers/loved.dart';
import 'package:takwira_app/views/fieldProfile/field_profile.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final loveProvider = StateNotifierProvider<Loved, bool>(((ref) {
  return Loved();
}));

class FieldCard extends ConsumerStatefulWidget {

  final dynamic? field;
  final IO.Socket? socket;

  const FieldCard({super.key, required this.field, this.socket});
  @override
  ConsumerState<FieldCard> createState() => _FieldCardState();
}

class _FieldCardState extends ConsumerState<FieldCard> {
  bool isLiked = false;
  dynamic? field;

  @override
  void initState() {
    getLiked();
    super.initState();
    
  }

  void getLiked()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('id') ?? '';
    field = widget.field;
    if (field['field']['likedPlayers'] != null && field['field']['likedPlayers'].contains(id)) {
      setState(() {
        isLiked = true;
      });
    }else{
      setState(() {
        isLiked = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    IO.Socket? socket = widget.socket;
    dynamic? field = widget.field;
    final fieldData = ref.watch(fieldDataProvider);
    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    List<Map<String, dynamic>> services = [
      {"service": "Cark Park", "icon": "assets/images/parking.png"},
      {"service": "Coffee", "icon": "assets/images/coffe.png"},
      {"service": "Changing Room", "icon": "assets/images/wc.png"},
      {"service": "Watter", "icon": "assets/images/water.png"},
    ];

    void addOrRemoveLike() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var username = prefs.getString('username') ?? '';
      if(!isLiked){
        socket?.emit('add-field-like',{
          'field' : field,
          'username' : username
        });
        setState(() {
          isLiked = true;
        });
      }else{
        socket?.emit('remove-field-like',{
          'field' : field,
          'username' : username
        });
        setState(() {
          isLiked = false;
        });
      }
    }

    List<dynamic> fieldServices = field['field']['services'];
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(left: width(2)),
          child: SizedBox(
            width: width(306.59),
            height: width(177),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.network(
                field['field']['image'],
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.6),
              ),
            ),
          ),
        ),
        Positioned(
          top: width(15),
          child: Container(
            width: width(70),
            height: width(17),
            decoration: BoxDecoration(
              color: const Color(0xFF599068).withOpacity(0.6),
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(width(3)),
                bottomRight: Radius.circular(width(3)),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(width(7), width(1), 0, 0),
              child: Text(
                '${field['field']['price']} DNT',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFFF1EED0),
                  fontSize: width(10),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: width(36),
          left: width(123),
          child: Text(
            field['field']['name'],
            style: TextStyle(
              color: const Color(0xFFF1EED0),
              fontSize: width(12),
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(
          width: width(308.59),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width(22)),
            child: Column(
              children: [
                SizedBox(height: width(65)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: fieldServices.map((serviceName) {
                        Map<String, dynamic> service = services.firstWhere(
                          (service) => service['service'] == serviceName,
                          orElse: () => {},
                        );
                        if (service.isNotEmpty) {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    service['icon'],
                                    width: width(10),
                                    height: width(10),
                                  ),
                                  SizedBox(width: width(5)),
                                  Text(
                                    service['service'],
                                    style: TextStyle(
                                      color: const Color(0xFFF1EED0),
                                      fontSize: width(10),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: width(2)),
                            ],
                          );
                        } else {
                          return SizedBox
                              .shrink(); 
                        }
                      }).toList(),
                    ),
                    Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/adress.png',
                              width: width(12),
                              height: width(12),
                            ),
                            SizedBox(width: width(2)),
                            Text(
                              fieldData.adress,
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(10),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width(2)),
                        Text(
                          '${(field['field']['distance'] as double).toStringAsFixed(2)} Km away',
                          style: TextStyle(
                            color: const Color(0xFFF1EED0),
                            fontSize: width(10),
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: width(123),
          left: width(235),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: const Color(0xFFF1EED0),
              backgroundColor: const Color(0xFF599068),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width(5)),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: width(15), vertical: width(10)), 
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FieldProfile(field: field),
                ),
              );
            },
            child: Text(
              'Book',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: width(10),
              ),
            ),
          ),
        ),
        Positioned(
          top: width(17),
          right: width(29),
          child: InkWell(
            onTap: () {
              addOrRemoveLike();
            },
            child: Ink(
              child: Image.asset(
                isLiked == false
                    ? 'assets/images/love.png'
                    : 'assets/images/loved.png',
                width: width(19),
                height: width(19),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
