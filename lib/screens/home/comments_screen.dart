import 'package:almira_front_end/api/api-post-comment-service.dart';
import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/utils/utils.dart' as utils;

class CommentsScreen extends StatefulWidget {
  final postId;
  final avatar;
  const CommentsScreen({Key? key, required this.postId, required this.avatar})
      : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future futurePostComment;
  final TextEditingController commentEditingController =
      TextEditingController();

  late List listOfDataComments;
  @override
  void initState() {
    futurePostComment = ApiPostCommentService().getPostComment(widget.postId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColor,
        title: const Text(
          'Comments',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context, "refresh");
          },
        ),
        centerTitle: false,
      ),
      body: Center(
        child: FutureBuilder(
          future: ApiPostCommentService().getPostComment(widget.postId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! $snapshot");
            } else if (snapshot.hasData) {
              final comment = snapshot.data!;
              return buildListViewComment(comment);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(widget.avatar),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentEditingController,
                    decoration: const InputDecoration(
                      hintText: 'Comment as ',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await ApiPostCommentService()
                      .addCommentToPost(
                          widget.postId, commentEditingController.text)
                      .then((value) async {
                    await ApiPostService().getPost();
                  }).catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  });
                  setState(() {
                    commentEditingController.text = "";
                  });
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: const Text(
                    'Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView buildListViewComment(listOfDataComment) {
    return ListView.builder(
      itemCount: listOfDataComment["post_comment"].length,
      itemBuilder: (context, index) {
        final comment = listOfDataComment;

        listOfDataComments = comment["post_comment"];
        final commentIndex = listOfDataComments[index];

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  commentIndex["user_data"]["image"]["image_url"].toString(),
                ),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: commentIndex["user_data"]["user_name"],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                            TextSpan(
                                text: " ${commentIndex["content"]}",
                                style: const TextStyle(color: Colors.black)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          commentIndex["created_at"],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: const Icon(
                  Icons.favorite_border,
                  size: 16,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
