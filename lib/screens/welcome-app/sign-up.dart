// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/responsive/responsive_layout.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:almira_front_end/utils/utils.dart' as utils;

import '../../utils/utils.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  ApiUserService _apiUserService = ApiUserService();

  File? _image;
  UploadTask? uploadImageCamera;

  bool isLoading = false;
  String url =
      'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg';

  TextEditingController emailController = TextEditingController();
  TextEditingController infomationController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  selectImage() async {
    File im = await pickCamera(ImageSource.gallery);
    // set state because we need to display the image we selected on the circle avatar
    setState(() {
      _image = im;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      appBar: AppBar(
        backgroundColor: defaultColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Stack(
                    children: [
                      _image != null
                          ? SizedBox(
                              height: 150.0,
                              width: 150.0,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(80),
                                child: Image.file(
                                  _image!,
                                  width: 450,
                                  height: 450,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          : const CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(
                                  'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg'),
                            ),
                      Positioned(
                        bottom: -10,
                        left: 80,
                        child: IconButton(
                          onPressed: selectImage,
                          icon: const Icon(Icons.add_a_photo),
                        ),
                      )
                    ],
                  ),
                  Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(10),
                      child: const Text(
                        'Almira',
                        style: TextStyle(fontSize: 32, fontFamily: 'BMDANIEL'),
                      )),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Sign up',
                      style:
                          TextStyle(fontSize: 20, fontFamily: 'OpenSansMedium'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: utils.requiredFieldEmail,
                      controller: emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 97, 95, 95)),
                        ),
                        labelText: "Enter your email",
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSansMedium',
                            color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: utils.requiredFieldUserName,
                      controller: userNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 97, 95, 95)),
                          ),
                          labelText: 'Enter your username',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSansMedium',
                              color: Color.fromARGB(255, 97, 95, 95))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      validator: utils.requiredFieldPassword,
                      obscureText: true,
                      controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 97, 95, 95)),
                        ),
                        labelText: 'Enter your password',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSansMedium',
                            color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: TextFormField(
                      obscureText: true,
                      // controller: passwordController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'This field password can not be empty';
                        }
                        if (value != passwordController.text) {
                          return 'Need to enter the correct password';
                        }
                        return null;
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 97, 95, 95)),
                        ),
                        labelText: 'Enter confirm password',
                        labelStyle: TextStyle(
                            fontFamily: 'OpenSansMedium',
                            color: Color.fromARGB(255, 97, 95, 95)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      controller: infomationController,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 97, 95, 95)),
                          ),
                          labelText: 'Enter infomation',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSansMedium',
                              color: Color.fromARGB(255, 97, 95, 95))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: utils.requiredFieldPhoneNumber,
                      controller: phoneNumberController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 97, 95, 95)),
                          ),
                          labelText: 'Phone Number',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSansMedium',
                              color: Color.fromARGB(255, 97, 95, 95))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultColor,
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(
                              fontSize: 12, fontFamily: 'OpenSanssBold'),
                        ),
                        onPressed: () async {
                          sigup();
                        },
                      )),
                ],
              ),
            )),
      ),
    );
  }

  void sigup() async {
    if (_formKey.currentState!.validate()) {
      String email = emailController.text;
      String userName = userNameController.text;
      String password = passwordController.text;
      setState(() {
        isLoading = true;
      });
      var s = _image;
      if (s != null) {
        String fileNamePickerCamera = basename(_image!.path);
        final file = File(_image!.path);
        final storageRef =
            FirebaseStorage.instance.ref().child('posts/$fileNamePickerCamera');
        uploadImageCamera = storageRef.putFile(file);

        final snapshot = await uploadImageCamera!.whenComplete(() {});
        final urlDowload = await snapshot.ref.getDownloadURL();
        print('Dowload Link : $urlDowload ');
        setState(() {
          url = urlDowload;
        });
      }

      final checkPer = await _handleLocationPermission();
      if (!checkPer) return;
      await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high)
          .then((Position position2) {
        setState(() => _currentPosition = position2);
        _getAddressFromLatLng(_currentPosition!);
      }).catchError((e) {
        debugPrint(e);
      });

      try {
        await _apiUserService
            .signUp(
                email,
                infomationController.text,
                userName,
                password,
                url,
                _currentPosition!.latitude,
                _currentPosition!.longitude,
                infomationController.text)
            .then((user) async {
          String token = await getTokenFromSF();

          Navigator.push(
            this.context,
            MaterialPageRoute(
              builder: (context) => ResponsiveLayout(
                token: token,
              ),
            ),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(this.context)
              .showSnackBar(SnackBar(content: Text(error.toString())));
        });
      } catch (err) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          this.context,
          err.toString(),
        );
      }
    }
  }

  Future pickCamera(ImageSource source) async {
    try {
      final ImagePicker _imagePicker = ImagePicker();
      final image = await _imagePicker.pickImage(source: source);
      if (image == null) return;
      final imageTpr = File(image.path);
      setState(() => this._image = imageTpr);
    } on PlatformException catch (e) {
      print(e);
    }
  }

  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(this.context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  //

}
