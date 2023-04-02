import 'package:almira_front_end/api/api-post-comment-service.dart';
import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/widgets/like_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  late Future futurePostComment;
  final TextEditingController commentEditingController =
      TextEditingController();
  final TextEditingController oldCommentEditingController =
      TextEditingController();

  late List listOfDataComments;
  bool isLikeAnimating = false;
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
                    style: TextStyle(color: defaultColor),
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

        return Slidable(
          // startActionPane: ActionPane(
          //   motion: const StretchMotion(),
          //   children: [SlidableAction(onPressed: (context) {})],
          // ),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              SlidableAction(
                flex: 2,
                onPressed: (context) async {
                  await ApiPostCommentService()
                      .deleteComment(
                          widget.postId, commentIndex["post_comment_id"])
                      .then((value) async {})
                      .catchError((error) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(error.toString())));
                  });
                  setState(() {});
                },
                icon: Icons.delete,
                backgroundColor: Colors.red,
                label: 'Delete',
              ),
              SlidableAction(
                flex: 2,
                onPressed: (context) async {
                  oldCommentEditingController.text = commentIndex["content"];
                  showDialog<void>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                      child: Container(
                        child: Scrollbar(
                          thickness: 3,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shrinkWrap: true,
                                children: [
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Form(
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              child: TextFormField(
                                                controller:
                                                    oldCommentEditingController,
                                                autovalidateMode:
                                                    AutovalidateMode
                                                        .onUserInteraction,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide(
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          97,
                                                                          95,
                                                                          95)),
                                                        ),
                                                        labelText:
                                                            'Edit Comment',
                                                        labelStyle: TextStyle(
                                                            fontFamily:
                                                                'OpenSansMedium',
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    97,
                                                                    95,
                                                                    95))),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: TextButton(
                                                    onPressed: (() async {
                                                      await ApiPostCommentService()
                                                          .editComment(
                                                              widget.postId,
                                                              commentIndex[
                                                                  "post_comment_id"],
                                                              oldCommentEditingController
                                                                  .text)
                                                          .then((e) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      }).catchError((error) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(error
                                                                    .toString())));
                                                      });
                                                      setState(() {
                                                        oldCommentEditingController
                                                            .text = "";
                                                      });
                                                    }),
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.green,
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      width: 114,
                                                      height: 27,
                                                      child: const Text(
                                                        "Edit",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 2),
                                                  child: TextButton(
                                                    onPressed: () async {
                                                      Navigator.pop(context);
                                                    },
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color: Colors.blue,
                                                        border: Border.all(
                                                          color: Colors.grey,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      width: 114,
                                                      height: 27,
                                                      child: const Text(
                                                        "Cancel",
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ]),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                icon: Icons.edit,
                backgroundColor: Colors.green,
                label: 'Edit',
              )
            ],
          ),
          child: Container(
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
                LikeAnimation(
                  isAnimating: commentIndex["is_liked_comment"],
                  smallLike: true,
                  child: IconButton(
                      onPressed: () async {
                        await ApiPostCommentService()
                            .likeComment(
                                widget.postId,
                                commentIndex["post_comment_id"],
                                commentIndex["is_liked_comment"])
                            .catchError((error) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(error.toString())));
                        });
                        setState(() {
                          isLikeAnimating = false;
                        });
                      },
                      icon: commentIndex["is_liked_comment"]
                          ? const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )
                          : const Icon(
                              Icons.favorite_border_outlined,
                              color: Colors.black,
                            )),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.green,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.red,
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }
}
