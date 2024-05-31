import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:takwira_app/data/user_data.dart';
import 'package:http/http.dart' as http;
import 'package:takwira_app/views/profile/profile.dart';
import 'dart:io';

class EditProfile extends ConsumerStatefulWidget {
  final dynamic? currentUser;
  const EditProfile({super.key, this.currentUser});

  @override
  ConsumerState<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _phoneNumber;
  late String _email;
  String? coverPath;
  Uint8List? coverImageBytes;
  String? profilePath;
  Uint8List? profileImageBytes;

  DateTime date = DateTime.now();
  bool used = false;

  void showDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: Color(0xff599068),
              onPrimary: Colors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
              ),
            ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      setState(() {
        date = value!;
        print(date);
      });
    });
    setState(() {
      used = true;
    });
  }


  String errorMessage = "";


  void editProfile() async {
  // print(profilePath);
  // final cloudinaryUrl = Uri.parse('https://api.cloudinary.com/v1_1/dqpfli00s/upload');
  // final cloudinaryRequest = http.MultipartRequest('POST', cloudinaryUrl)
  //   ..fields['upload_preset'] = 'nz6kggn0'
  //   ..files.add(http.MultipartFile.fromBytes(
  //     'file',
  //     await File(profilePath!).readAsBytes(),
  //     filename: 'profile_image.jpg', // Provide a filename
  //   ));

  // final cloudinaryResponse = await cloudinaryRequest.send();

  

  // if (cloudinaryResponse.statusCode == 200) {
  //   final cloudinaryResponseData = await cloudinaryResponse.stream.toBytes();
  //   final cloudinaryResponseString = String.fromCharCodes(cloudinaryResponseData);
  //   final cloudinaryJsonMap = jsonDecode(cloudinaryResponseString);
  //   final imageUrl = cloudinaryJsonMap['url'];

    final updateUrl = Uri.parse('https://takwira.me/api/editprofile');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var username = prefs.getString('username') ?? '';
    var token = prefs.getString('token') ?? '';
    final updateResponse = await http.post(
      updateUrl,
      headers: {
        'flutter': 'true',
        'authorization': token,
      },
      body: {
        'username': username,
        'token': token,
        'fName': _firstName,
        'lName': _lastName,
        'phone': _phoneNumber,
        'email': _email,
        'date' : date.toString().split(" ")[0]
        // 'image': imageUrl,
      },
    );

    if (updateResponse.statusCode == 200) {
      var responseBody = jsonDecode(updateResponse.body);
      var bodySuccess = responseBody['success'];
      if (bodySuccess) {
        setState(() {
          errorMessage = '';
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Profile(),
          ),
        );
      } else {
        var bodyError = responseBody['error'];
        setState(() {
          errorMessage = bodyError;
        });
      }
    } else {
      setState(() {
        errorMessage = 'Failed to update profile: ${updateResponse.statusCode}';
      });
    }
  // } else {
  //   setState(() {
  //     errorMessage = 'Failed to upload image to Cloudinary: ${cloudinaryResponse.statusCode}';
  //   });
  // }
}



  @override
  Widget build(BuildContext context) {
    final profileData = ref.watch(userDataProvider);

    double a = 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double width(double width) {
      a = width / 430;
      return screenWidth * a;
    }

    return Scaffold(
      backgroundColor: const Color(0xff343835),
      appBar: AppBar(
        backgroundColor: const Color(0xff343835),
        iconTheme: const IconThemeData(color: Color(0xFFF1EED0)),
        title: const Padding(
          padding: EdgeInsets.all(10.0),
          child: Text(
            'Edit Profile',
            style: TextStyle(
              color: Color(0xFFF1EED0),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SizedBox(
              width: screenWidth,
              height: width(144),
              child: InkWell(
                child: Ink(
                  child: coverPath != null
                      ? Image.file(
                          File(coverPath!),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/coverPhoto.png',
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            
            Column(
              children: [
                SizedBox(height: width(65)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () async {
                        try {
                          final pickedFile = await ImagePicker()
                              .pickImage(source: ImageSource.gallery);
                          if (pickedFile != null) {
                            if (kIsWeb) {
                              final bytes = await pickedFile.readAsBytes();
                              setState(() {
                                profileImageBytes = bytes;
                                profilePath = pickedFile.path;
                              });
                            } else {
                              setState(() {
                                profilePath = pickedFile.path;
                              });
                            }
                          }
                        } on PlatformException catch (e) {
                          print('Failed to pick image: $e');
                        }
                      },
                      child: Ink(
                        child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/profileIcon.png',
                              width: width(120),
                              height: width(147),
                            ),
                            SizedBox(
                              width: width(100),
                              height: width(147),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(width(5), width(27), width(5), width(27)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(width(60)),
                                  child: profileImageBytes != null
                                      ? Image.memory(
                                          profileImageBytes!,
                                          fit: BoxFit.cover,
                                        )
                                      : profilePath != null
                                          ? Image.file(
                                              File(profilePath!),
                                              fit: BoxFit.cover,
                                            )
                                          : Image.network(
                                              '${widget.currentUser['image']}',
                                              fit: BoxFit.cover,
                                            ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: width(40)),
                Form(
                  key: _formKey,
                  child: Container(
                    margin:
                        EdgeInsets.fromLTRB(width(20), 0, width(20), width(20)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: width(15)),
                                Text(
                                  'First name',
                                  style: TextStyle(
                                      color: Color(0xffBFBCA0),
                                      fontSize: width(16),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: width(20)),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Color(0xFFF1EED0),
                                    fontSize: width(14)),
                                initialValue: widget.currentUser['fName'],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your First name';
                                  } else if (!RegExp(r'^[a-zA-Z]+$')
                                      .hasMatch(value)) {
                                    return 'First name must contain only alphabetic characters';
                                  } else if (value.length < 3 ||
                                      value.length > 60) {
                                    return 'First name must be 3 to 60 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _firstName = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width(30)),
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: width(15)),
                                Text(
                                  'Last name',
                                  style: TextStyle(
                                      color: Color(0xffBFBCA0),
                                      fontSize: width(16),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: width(20)),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Color(0xFFF1EED0),
                                    fontSize: width(14)),
                                initialValue: widget.currentUser['lName'],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Last name';
                                  } else if (!RegExp(r'^[a-zA-Z]+$')
                                      .hasMatch(value)) {
                                    return 'Last name must contain only alphabetic characters';
                                  } else if (value.length < 3 ||
                                      value.length > 60) {
                                    return 'Last name must be 3 to 60 characters long';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _lastName = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width(30)),
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: width(15)),
                                Text(
                                  'Username',
                                  style: TextStyle(
                                      color: Color(0xffBFBCA0),
                                      fontSize: width(16),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: width(20)),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Color.fromARGB(255, 116, 116, 116),
                                    fontSize: width(14)),
                                initialValue: widget.currentUser['username'],
                                readOnly: true,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width(30)),
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: width(15)),
                                Text(
                                  'Phone number',
                                  style: TextStyle(
                                      color: Color(0xffBFBCA0),
                                      fontSize: width(16),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: width(20)),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Color(0xFFF1EED0),
                                    fontSize: width(14)),
                                initialValue: widget.currentUser['phone'],
                                decoration: InputDecoration(
                                  counterText: '',
                                ),
                                maxLength: 8,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your phone number';
                                  } else if (!RegExp(r'^[0-9]+$')
                                      .hasMatch(value)) {
                                    return 'Phone number must contain only numbers';
                                  } else {
                                    int? phoneNumber = int.tryParse(value);
                                    if (phoneNumber == null ||
                                        phoneNumber < 20000000 ||
                                        phoneNumber > 99999999) {
                                      return 'Phone number doesn\'t exist';
                                    }
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _phoneNumber = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width(30)),
                        Row(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: width(15)),
                                Text(
                                  'Email',
                                  style: TextStyle(
                                      color: Color(0xffBFBCA0),
                                      fontSize: width(16),
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(width: width(20)),
                            Expanded(
                              child: TextFormField(
                                style: TextStyle(
                                    color: Color(0xFFF1EED0),
                                    fontSize: width(14)),
                                initialValue: widget.currentUser['email'],
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email';
                                  } else if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(value)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width(30)),
                        Row(
                          children: [
                            Text(
                              'Date of birth',
                              style: TextStyle(
                                color: Color(0xffBFBCA0),
                                fontSize: width(16),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: width(20)),
                            IconButton(
                              onPressed: showDate,
                              icon: Row(
                                children: [
                                  Image.asset(
                                    'assets/images/date.png',
                                    width: width(16),
                                    height: width(16),
                                  ),
                                  SizedBox(width: width(5)),
                                  Text(
                                    used == false
                                        ? widget.currentUser['birthdate']
                                            .toString()
                                            .split('T')[0]
                                            .toString()
                                            .split(" ")[0]
                                        : date.toString().split(" ")[0],
                                    style: TextStyle(
                                      color: const Color(0xFFF1EED0),
                                      fontSize: width(12),
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: width(10)),
                        Center(
                          child: Column(
                            children: [
                              SizedBox(height: width(20)),
                              Text(
                                errorMessage,
                                style: TextStyle(
                                  color: Color.fromARGB(255, 249, 27, 27),
                                  fontSize: width(14),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: width(140),
              right: width(130),
              child: IconButton(
                onPressed: () async {
                  try {
                    final pickedFile = await ImagePicker()
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      if (kIsWeb) {
                        final bytes = await pickedFile.readAsBytes();
                        setState(() {
                          profileImageBytes = bytes;
                          profilePath = pickedFile.path;
                        });
                      } else {
                        setState(() {
                          profilePath = pickedFile.path;
                        });
                      }
                    }
                  } on PlatformException catch (e) {
                    print('Failed to pick image: $e');
                  }
                },
                icon: Image.asset(
                  'assets/images/editPhoto.png',
                  width: width(35),
                  height: width(35),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: width(50),
        color: const Color(0xff599068),
        child: TextButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              editProfile();
            }
          },
          child: Text(
            'Save',
            style: TextStyle(
              color: const Color(0xffF1EED0),
              fontSize: width(16),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
