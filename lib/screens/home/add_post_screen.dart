import 'dart:io';

import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  // Uint8List? _file;
  bool _toggledCheck = false;
  File? _image;
  bool isLoading = false;
  UploadTask? uploadImageCamera;
  ApiPostService _apiPostService = ApiPostService();

  final TextEditingController _descriptionController = TextEditingController();

  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Post'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  File file = await pickCamera(ImageSource.camera);
                  setState(() {
                    _image = file;
                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  File file = await pickCamera(ImageSource.gallery);
                  setState(() {
                    _image = file;
                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  void postImage() async {
    setState(() {
      isLoading = true;
    });

    String fileNamePickerCamera = basename(_image!.path);
    final file = File(_image!.path);
    final storageRef =
        FirebaseStorage.instance.ref().child('posts/$fileNamePickerCamera');
    uploadImageCamera = storageRef.putFile(file);

    final snapshot = await uploadImageCamera!.whenComplete(() {});
    final urlDowload = await snapshot.ref.getDownloadURL();
    print('Dowload Link : $urlDowload ');

    try {
      // upload to storage and db
      await _apiPostService
          .addNewPost(_descriptionController.text, urlDowload, _toggledCheck)
          .then((value) {
        setState(() {
          isLoading = false;
        });
        showSnackBar(
          this.context,
          'Posted!',
        );
        clearImage();
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

  void clearImage() {
    setState(() {
      _image = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _image == null
        ? Center(
            child: IconButton(
              icon: const Icon(
                Icons.upload,
              ),
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: defaultColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text(
                'Post to',
              ),
              centerTitle: false,
              actions: <Widget>[
                TextButton(
                  onPressed: postImage,
                  child: const Text(
                    "POST",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                )
              ],
            ),
            // POST FORM
            body: Column(
              children: <Widget>[
                isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(padding: EdgeInsets.only(top: 0.0)),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                        height: 60.0,
                        width: 60.0,
                        child: ClipRRect(
                          child: Image.file(
                            _image!,
                            width: 450,
                            height: 450,
                            fit: BoxFit.cover,
                          ),
                        )),
                    SizedBox(
                      height: 60.0,
                      width: 300.0,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                            hintText: "Write a caption...",
                            border: InputBorder.none),
                        maxLines: 8,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SwitchListTile(
                    title: const Text("Only me mode"),
                    value: _toggledCheck,
                    onChanged: (bool value) {
                      setState(() => _toggledCheck = value);
                    },
                  ),
                ),
                const Divider(),
              ],
            ),
          );
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
}
