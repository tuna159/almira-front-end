// ignore_for_file: unnecessary_null_comparison

import 'dart:io';

import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/responsive/responsive_layout.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import 'package:almira_front_end/utils/utils.dart' as utils;

import '../../utils/utils.dart';

final GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

class EditProfile extends StatefulWidget {
  final avatar;
  final userName;
  final introduction;
  const EditProfile({
    Key? key,
    required this.avatar,
    required this.userName,
    required this.introduction,
  }) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  ApiUserService _apiUserService = ApiUserService();

  File? _image;
  UploadTask? uploadImageCamera;

  bool isLoading = false;
  String url =
      'https://icon-library.com/images/default-user-icon/default-user-icon-13.jpg';

  TextEditingController infomationController = TextEditingController();
  TextEditingController userNameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    infomationController.text = widget.introduction;
    userNameController.text = widget.userName;
    super.initState();
  }

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
        title: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(10),
            child: const Text(
              "Edit Profile",
              style: TextStyle(fontSize: 20, fontFamily: 'OpenSansMedium'),
            )),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context, "refresh");
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              updateMe();
            },
            child: const Text(
              "Done",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          )
        ],
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
                                  fit: BoxFit.cover,
                                ),
                              ))
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage: NetworkImage(widget.avatar),
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
                    child: const Text(''),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(
                      validator: utils.requiredFieldEmail,
                      controller: userNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 97, 95, 95)),
                        ),
                        labelText: "Enter your user name",
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
                      controller: infomationController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 97, 95, 95)),
                          ),
                          labelText: 'Enter your infomation',
                          labelStyle: TextStyle(
                              fontFamily: 'OpenSansMedium',
                              color: Color.fromARGB(255, 97, 95, 95))),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )),
      ),
    );
  }

  void updateMe() async {
    if (_formKey.currentState!.validate()) {
      String userName = userNameController.text;
      String infomation = infomationController.text;
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

      try {
        await _apiUserService
            .updateMe(infomationController.text, userNameController.text, url)
            .then((user) {})
            .catchError((error) {
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

  //

}
