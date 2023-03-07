import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/routes/routes.dart';
import 'package:almira_front_end/widgets/like_animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:almira_front_end/utils/utils.dart' as utils;
import 'package:http/http.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool isLikeAnimating = false;
  bool isLoading = true;

  late List listOfDataImage;
  late Future futurePost;
  late List listPostLike;
  late List listPost;
  late int id;

  @override
  void initState() {
    super.initState();
    futurePost = ApiPostService().getPost();
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
      body: Center(
        child: FutureBuilder(
          future: futurePost,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! ${snapshot}");
            } else if (snapshot.hasData) {
              final posts = snapshot.data!;
              return buildListView(posts);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: utils.bColor,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
            ),
            label: '',
          ),
        ],
      ),
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        content: const Text('Example Dialog'),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close'),
          )
        ],
      ),
    );
  }

  ListView buildListView(List listOfData) {
    return ListView.builder(
        itemCount: listOfData.length,
        itemBuilder: (context, index) {
          final post = listOfData[index];
          // print(post);
          listOfDataImage = post["image"];
          final postImage = listOfDataImage[0];
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(right: 0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(post["user_data"]
                                ["user_image"]["image_url"]
                            .toString()),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                post["user_data"]["nick_name"].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => Dialog(
                                    backgroundColor: Colors.white,
                                    child: ListView(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                      shrinkWrap: true,
                                      children: [
                                        'Delete',
                                      ]
                                          .map((e) => InkWell(
                                                onTap: () async {
                                                  await ApiPostService()
                                                      .deletePost(
                                                          post["post_id"]);
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 12,
                                                    vertical: 16,
                                                  ),
                                                  child: Text(e),
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.more_vert,
                        ),
                      ),
                    ],
                  ),
                ),
                // Image Section

                GestureDetector(
                  onDoubleTap: () async {
                    // await ApiPostService()
                    //     .likePost(post["post_id"])
                    //     .then((value) async {
                    //   listPostLike = await ApiPostService().getPost();
                    //   print(listPostLike[index].toString());
                    //   setState(
                    //     () {
                    //       listPostLike[index];
                    //     },
                    //   );
                    // }).catchError((error) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(content: Text(error.toString())));
                    // });
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          postImage['image_url'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(
                          milliseconds: 200,
                        ),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          isAnimating: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          child: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 120,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // //Like Comment Section

                Row(
                  children: [
                    // Like Widget
                    LikeAnimation(
                      isAnimating: post["is_liked"],
                      smallLike: true,
                      child: IconButton(
                          onPressed: () async {
                            await ApiPostService()
                                .likePost(post["post_id"])
                                .then((value) async {
                              listPostLike = await ApiPostService().getPost();
                              print(listPostLike[index].toString());
                              setState(
                                () {
                                  listPostLike[index];
                                },
                              );
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString())));
                            });
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                          icon: post["is_liked"]
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_border_outlined,
                                  color: Colors.black,
                                )),
                    ),

                    // Comment Section
                    IconButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         CommentsScreen(postId: post["post_id"]),
                        //   ),
                        // );
                      },
                      icon: Icon(
                        Icons.comment_outlined,
                      ),
                    ),

                    // Share Widget

                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send_outlined,
                      ),
                    ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.bookmark_border,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Description & Number of comments

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post["like_count"].toString() + " likes",
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                            children: [
                              TextSpan(
                                text: post["user_data"]["nick_name"].toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: " ${post["content"]}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => CommentsScreen(
                          //       snap: widget.snap,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          child: Text(
                            'View all ${post["comment_count"]} comments',
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                        ),
                        child: Text(
                          post["created"].toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        });
    // Header Section
  }
}
