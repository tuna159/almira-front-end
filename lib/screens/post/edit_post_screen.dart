import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/screens/home/home-app.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class EditPostScreen extends StatefulWidget {
  final postId;
  final content;
  final String imageUrl;
  const EditPostScreen(
      {Key? key,
      required this.postId,
      required this.content,
      required this.imageUrl})
      : super(key: key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  bool toggled = false;
  bool isLoading = false;
  ApiPostService _apiPostService = ApiPostService();
  String dropdownValue = postType1.first;
  String valueType = '';

  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    _descriptionController.text = widget.content;

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColor,
        title: const Text(
          'Edit Post',
        ),
        centerTitle: false,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              ApiPostService()
                  .updatePost(
                      _descriptionController.text, toggled, widget.postId)
                  .then((user) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeApp(),
                  ),
                );
              }).catchError((error) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(error.toString())));
              });
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
                    child: Image.network(
                      widget.imageUrl,
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
                      hintText: "Write a caption...", border: InputBorder.none),
                  maxLines: 8,
                ),
              ),
            ],
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
                items:
                    postType1.map<DropdownMenuItem<String>>((String valueType) {
                  return DropdownMenuItem<String>(
                    value: valueType,
                    child: Text(valueType),
                  );
                }).toList(),
              ),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}

List<String> postType1 = <String>['Public', 'Friends', 'Only Me'];
