import 'package:almira_front_end/api/api-gift-service.dart';
import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/screens/header/message_page.dart';
import 'package:almira_front_end/screens/home/comments_screen.dart';
import 'package:almira_front_end/screens/home/gift_post.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/text.dart';
import 'package:almira_front_end/widgets/custom_button.dart';
import 'package:almira_front_end/widgets/like_animation.dart';

import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool isLikeAnimating = false;
  bool isCheckUser = false;
  late List listOfDataImage;
  late Future futurePost;
  late List listOfGift;
  TextEditingController messageReportController = TextEditingController();

  int selectedCard = -1;

  @override
  void initState() {
    super.initState();
    ApiPostService().getPost();
    ApiGiftService().getAllGift();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Almira'),
        automaticallyImplyLeading: false,
        backgroundColor: defaultColor,
        titleTextStyle: progressHeaderStyle,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.messenger_outline_sharp),
            tooltip: 'Show Snackbar',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: FutureBuilder(
          future: ApiPostService().getPost(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! $snapshot");
            } else if (snapshot.hasData) {
              final posts = snapshot.data!;
              return buildListViewPost(posts);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ListView buildListViewPost(List listOfData) {
    return ListView.builder(
        itemCount: listOfData.length,
        itemBuilder: (context, index) {
          final post = listOfData[index];
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
                      GestureDetector(
                        onTap: (() {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                uid: post["user_data"]["user_id"],
                              ),
                            ),
                          );
                        }),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(post["user_data"]
                                  ["user_image"]["image_url"]
                              .toString()),
                        ),
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
                        onPressed: () async {
                          final userPost = post["user_data"]["user_id"];
                          String token = await getTokenFromSF();
                          String uid = await decrypToken(token);
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => Dialog(
                              child: Container(
                                child: Scrollbar(
                                  thickness: 3,
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: ListView(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shrinkWrap: true,
                                        children: [
                                          userPost == uid
                                              ? Column(
                                                  children: [
                                                    CustomButton(
                                                        function: () async {
                                                          await ApiPostService()
                                                              .deletePost(post[
                                                                  "post_id"])
                                                              .then((e) {
                                                            Navigator.pop(
                                                                context);
                                                            setState(() {});
                                                          }).catchError(
                                                                  (error) {
                                                            ScaffoldMessenger
                                                                    .of(context)
                                                                .showSnackBar(SnackBar(
                                                                    content: Text(
                                                                        error
                                                                            .toString())));
                                                          });
                                                        },
                                                        backgroundColor:
                                                            backgroundColor,
                                                        borderColor:
                                                            Colors.grey,
                                                        text: "Delete",
                                                        textColor:
                                                            Colors.black),
                                                    CustomButton(
                                                        function: () async {},
                                                        backgroundColor:
                                                            backgroundColor,
                                                        borderColor:
                                                            Colors.grey,
                                                        text: "Edit",
                                                        textColor: Colors.black)
                                                  ],
                                                )
                                              : SingleChildScrollView(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            16.0),
                                                    child: Form(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child:
                                                                TextFormField(
                                                              controller:
                                                                  messageReportController,
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .text,
                                                              decoration:
                                                                  const InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide: BorderSide(
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                97,
                                                                                95,
                                                                                95)),
                                                                      ),
                                                                      labelText:
                                                                          'Message Report',
                                                                      labelStyle: TextStyle(
                                                                          fontFamily:
                                                                              'OpenSansMedium',
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              97,
                                                                              95,
                                                                              95))),
                                                            ),
                                                          ),
                                                          CustomButton(
                                                              function:
                                                                  () async {
                                                                await ApiPostService()
                                                                    .reportPost(
                                                                        post[
                                                                            "post_id"],
                                                                        messageReportController
                                                                            .text)
                                                                    .then((e) {
                                                                  Navigator.pop(
                                                                      context);
                                                                  setState(
                                                                      () {});
                                                                }).catchError(
                                                                        (error) {
                                                                  ScaffoldMessenger.of(
                                                                          context)
                                                                      .showSnackBar(SnackBar(
                                                                          content:
                                                                              Text(error.toString())));
                                                                });
                                                                setState(() {
                                                                  messageReportController
                                                                      .text = "";
                                                                });
                                                              },
                                                              backgroundColor:
                                                                  Colors.red,
                                                              borderColor:
                                                                  Colors.grey,
                                                              text: "Report",
                                                              textColor:
                                                                  Colors.white)
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
                    await ApiPostService()
                        .likePost(post["post_id"], post["is_liked"])
                        .catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    });
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
                            color: Colors.white,
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
                                .likePost(post["post_id"], post["is_liked"])
                                .catchError((error) {
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
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                                postId: post["post_id"],
                                avatar: post["user_data"]["user_image"]
                                    ["image_url"]),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                      ),
                    ),

                    // Share Widget
                    IconButton(
                      icon: const Icon(
                        Icons.card_giftcard_outlined,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GiftsPost(
                                postId: post["post_id"],
                                uid: post["user_data"]["user_id"]),
                          ),
                        );
                      },
                    ),
                  ],
                ),

                // Description & Number of comments

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${post["like_count"]} likes",
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          String refresh = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                postId: post["post_id"],
                                avatar: post["user_data"]["user_image"]
                                    ["image_url"],
                              ),
                            ),
                          );
                          if (refresh == "refresh") {
                            setState(() {});
                          }
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
