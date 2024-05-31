import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/data/user_data.dart';
import 'package:takwira_app/views/profile/primary_position.dart';
import 'package:takwira_app/views/profile/profile.dart';
import 'package:takwira_app/views/profile/secondary_position.dart';

class Right extends StateNotifier<bool> {
  Right() : super(true);
  void otherFoot() {
    state = !state;
  }
}

final footProvider = StateNotifierProvider<Right, bool>(((ref) {
  return Right();
}));

class EditProfileDetails extends ConsumerStatefulWidget {
  final dynamic? currentUser;
  final VoidCallback toggleEditing;

  const EditProfileDetails(
      {super.key, this.currentUser, required this.toggleEditing});

  @override
  _EditProfileDetailsState createState() => _EditProfileDetailsState();
}

class _EditProfileDetailsState extends ConsumerState<EditProfileDetails> {
  String selectedPosition = '';
  List<String> availablePosition = [
    'GK',
    'CB',
    'RB',
    'LB',
    'CDM',
    'CM',
    'CAM',
    'RW',
    'LW',
    'ST'
  ];

  List<String> selectedPositions = [];
  List<String> availablePositions = [
    'GK',
    'CB',
    'RB',
    'LB',
    'CDM',
    'CM',
    'CAM',
    'RW',
    'LW',
    'ST'
  ];

  late String _height;
  late String _weight;
  late String _jerseyNumber;
  late bool foot;
  String? errorMessage;

  void editAdvancedProfileSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    print('jawk mrigl');

    final Uri url = Uri.parse(
        'https://takwira.me/api/editadvancedprofilesettings?username=$username');

    try {
      final http.Response response = await http.post(
        url,
        headers: {
          'flutter': 'true',
          'authorization': token,
        },
        body: {
          'height': _height.toString(),
          'weight': _weight.toString(),
          'jerseyNumber': _jerseyNumber.toString(),
          'selectedPosition': selectedPosition.toString(),
          'selectedPositions': selectedPositions.toString(),
          'foot': foot.toString(),
        },
      );

      if (response.statusCode == 200) {
        var responseBody = json.decode(response.body);
        var bodySuccess = responseBody['success'];
        print(bodySuccess);
        if (bodySuccess) {
          setState(() {
            errorMessage = "";
          });
          
        } else {
          setState(() {
            errorMessage =
                "Field Name should be unique, description should not be empty, the invited players should not exceed 6 players.";
          });
        }
      } else {
        setState(() {
          errorMessage =
              "Failed to update profile settings. Status code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileData = widget.currentUser;
    print('this is profile data : $profileData');
    final right = widget.currentUser['foot'];
    final formKey = GlobalKey<FormState>();

    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width(62)),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: width(30)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: width(70)),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(width(20)),
                    border: Border.all(color: Color(0xFFBD4747)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width(10)),
                    child: IconButton(
                      onPressed: widget.toggleEditing,
                      icon: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cancel Editing',
                            style: TextStyle(
                              color: Color(0xFFBD4747),
                              fontSize: width(14),
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          Image.asset(
                            'assets/images/cancelEdition.png',
                            width: width(16),
                            height: width(16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: width(30)),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       'Age',
              //       style: TextStyle(
              //         color: const Color(0xFFF1EED0),
              //         fontSize: width(16),
              //         fontWeight: FontWeight.normal,
              //       ),
              //     ),
              //     SizedBox(
              //       width: width(90),
              //       child: Text(
              //         '$age Years',
              //         textAlign: TextAlign.center,
              //         style: TextStyle(
              //           color: const Color(0xFFF1EED0),
              //           fontSize: width(16),
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: width(28)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Height',
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width(15)),
                    child: SizedBox(
                      width: width(60),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(16),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              initialValue: '${profileData['height']}',
                              decoration: InputDecoration(
                                counterText: '',
                              ),
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Height';
                                } else {
                                  int? height = int.tryParse(value);
                                  if (height == null ||
                                      height < 50 ||
                                      height > 250) {
                                    return 'Height should be enter 50 cm and 250 cm';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _height = value!;
                              },
                            ),
                          ),
                          SizedBox(width: width(5)),
                          Text(
                            'cm',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFF1EED0),
                              fontSize: width(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width(16)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weight',
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: width(15)),
                    child: SizedBox(
                      width: width(60),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              style: TextStyle(
                                color: const Color(0xFFF1EED0),
                                fontSize: width(16),
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              initialValue: '${profileData['weight']}',
                              decoration: InputDecoration(
                                counterText: '',
                              ),
                              maxLength: 3,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your Weight';
                                } else {
                                  int? height = int.tryParse(value);
                                  if (height == null ||
                                      height < 20 ||
                                      height > 300) {
                                    return 'Height should be enter 20 cm and 300 cm';
                                  }
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _weight = value!;
                              },
                            ),
                          ),
                          SizedBox(width: width(5)),
                          Text(
                            'Kg',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFFF1EED0),
                              fontSize: width(16),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: width(27)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Foot',
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        ref.read(footProvider.notifier).otherFoot();
                      },
                      child: right == true
                          ? Row(
                              children: [
                                Transform.rotate(
                                  angle: 30 * (3.141592653589793 / 180),
                                  child: Image.asset(
                                    'assets/images/right.png',
                                    width: width(30),
                                    height: width(30),
                                  ),
                                ),
                                SizedBox(width: width(10)),
                                Text(
                                  'Right',
                                  style: TextStyle(
                                    color: const Color(0xFFF1EED0),
                                    fontSize: width(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          : Row(
                              children: [
                                Text(
                                  'Left',
                                  style: TextStyle(
                                    color: const Color(0xFFF1EED0),
                                    fontSize: width(16),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: width(10)),
                                Transform.rotate(
                                  angle: -30 * (3.141592653589793 / 180),
                                  child: Image.asset(
                                    'assets/images/left.png',
                                    width: width(30),
                                    height: width(30),
                                  ),
                                ),
                              ],
                            )),
                ],
              ),
              SizedBox(height: width(39)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Jersey Number',
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            'assets/images/jerseyNumber.png',
                            width: width(50),
                            height: width(50),
                          ),
                          Positioned(
                            top: width(1),
                            left: width(1),
                            child: SizedBox(
                              width: width(50),
                              child: TextFormField(
                                style: TextStyle(
                                  color: const Color(0xFFF1EED0),
                                  fontSize: width(16),
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                                initialValue: '${profileData['jerseyNumber']}',
                                decoration: InputDecoration(
                                  counterText: '',
                                ),
                                maxLength: 2,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Jersey number';
                                  } else {
                                    int? jersyNumber = int.tryParse(value);
                                    if (jersyNumber == null ||
                                        jersyNumber < 1 ||
                                        jersyNumber > 99) {
                                      return 'Jersey number should be enter 1 and 99';
                                    }
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _jerseyNumber = value!;
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: width(15)),
                    ],
                  ),
                ],
              ),
              SizedBox(height: width(30)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Primary Position',
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    width: width(90),
                    child: PrimaryPosition(
                      selectedPosition: selectedPosition,
                      availablePositions: availablePosition,
                      onPositionSelected: (position) {
                        setState(() {
                          selectedPosition = position;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: width(23)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Secondary Positions',
                    style: TextStyle(
                      color: const Color(0xFFF1EED0),
                      fontSize: width(16),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(
                    width:
                        selectedPositions.length < 2 ? width(90) : width(128),
                    child: SecondaryPosition(
                      selectedPositions: selectedPositions,
                      availablePositions: availablePositions,
                      onPositionsSelected: (positions) {
                        setState(() {
                          selectedPositions = positions;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Text(
                'You can\'t choose more than\ntwo Secondary Positions',
                style: TextStyle(
                  color: const Color(0xFFD1C86F),
                  fontSize: width(9),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: width(40)),
              SizedBox(
                width: width(screenWidth),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(width(9)),
                      ),
                      foregroundColor: const Color(0xFFF1EED0),
                      backgroundColor: const Color(0xFF599068),
                      padding: EdgeInsets.symmetric(
                          horizontal: width(15), vertical: width(20)),
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        widget.toggleEditing();
                        foot = right;
                      }
                      editAdvancedProfileSettings();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ),
                      );
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: width(12),
                      ),
                    )),
              ),
              SizedBox(height: width(20)),
            ],
          ),
        ),
      ),
    );
  }
}
