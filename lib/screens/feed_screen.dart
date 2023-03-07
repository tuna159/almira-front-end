import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/widgets/post_card.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/utils/utils.dart' as utils;

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List postData = [];
  @override
  void initState() {
    initData();
    super.initState();
  }

  Future initData() async {
    List data = await ApiPostService().getPost();
    setState(() {
      postData = data;
    });
  }

  Future loadData() async {
    print('double tapped');
    // initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almira'),
        automaticallyImplyLeading: false,
        backgroundColor: utils.defaulColor,
        titleTextStyle: utils.getProgressHeaderStyle(),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.messenger_outline_sharp),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('This is a snackbar')));
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: postData.length,
        itemBuilder: (context, index) => PostCard(
          snap: postData[index]!,
          loadData: loadData(),
        ),
      ),
    );
  }
}
