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
  final bool _toggledCheck = false;
  List<XFile>? _imageFiles;
  final List<String> _downloadUrls = [];
  bool isLoading = false;
  final ApiPostService _apiPostService = ApiPostService();
  int postTypePost = 0;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController postType = TextEditingController();
  String dropdownValue = postType1.first;
  String valueType = '';

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
                  final pickedFile =
                      await ImagePicker().pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _imageFiles = [pickedFile];
                    });
                  }
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  final pickedFiles = await ImagePicker().pickMultiImage();

                  setState(() {
                    _imageFiles = pickedFiles;
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
    if (dropdownValue == "Public") {
      setState(() {
        postTypePost = 0;
      });
    } else if (dropdownValue == "Friends") {
      setState(() {
        postTypePost = 1;
      });
    } else {
      setState(() {
        postTypePost = 2;
      });
    }

    print(postTypePost);

    setState(() {
      isLoading = true;
    });

    for (var i = 0; i < _imageFiles!.length; i++) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('images/${DateTime.now().toString()}-$i');
      final file = File(_imageFiles![i].path);

      await storageRef.putFile(File(file.path));
      final url = await storageRef.getDownloadURL();
      _downloadUrls.add(url);
    }
    try {
      // upload to storage and db
      await _apiPostService
          .addNewPost(_descriptionController.text, _downloadUrls, _toggledCheck,
              postTypePost)
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
      _imageFiles = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _imageFiles == null
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
                          File(_imageFiles![0].path),
                          width: 450,
                          height: 450,
                          fit: BoxFit.cover,
                        ))),
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
                SizedBox(
                  width: 10,
                ),
                Row(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(
                        top: 1,
                        left: 10,
                      ),
                      child: Text(
                        "Select audience",
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    DropdownButton<String>(
                      value: dropdownValue,
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                          valueType = value;
                        });
                      },
                      items: postType1
                          .map<DropdownMenuItem<String>>((String valueType) {
                        return DropdownMenuItem<String>(
                          value: valueType,
                          child: Text(valueType),
                        );
                      }).toList(),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}

List<String> postType1 = <String>['Public', 'Friends', 'Only Me'];
