import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/screens/header/message_page.dart';
import 'package:almira_front_end/screens/home/comments_screen.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/text.dart';
import 'package:almira_front_end/widgets/like_animation.dart';
import 'package:almira_front_end/widgets/selectable_image.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class HomeApp extends StatefulWidget {
  const HomeApp({super.key});

  @override
  State<HomeApp> createState() => _HomeAppState();
}

class _HomeAppState extends State<HomeApp> {
  bool isLikeAnimating = false;

  late List listOfDataImage;
  late Future futurePost;

  int selectedCard = -1;

  final _images = [
    "https://znews-photo.zingcdn.me/w660/Uploaded/qhj_yvobvhfwbv/2018_07_18/Nguyen_Huy_Binh1.jpg",
    "https://deviet.vn/wp-content/uploads/2019/04/vuong-quoc-anh.jpg",
    "https://vietjet.net/includes/uploads/2020/12/nuoc-anh-thuoc-chau-nao-600x388.jpg",
  ];

  @override
  void initState() {
    _images;
    futurePost = ApiPostService().getPost();
    super.initState();
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
                          // final userPost = post["user_data"]["user_id"];
                          // String token = await getTokenFromSF();
                          // String uid = await decrypToken(token);

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
                                                          post["post_id"])
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
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                                child: Scrollbar(
                              thickness: 3,
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                                child: SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  child: Column(
                                    children: [
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics: BouncingScrollPhysics(),
                                        itemCount: _images.length,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                childAspectRatio: 1,
                                                crossAxisCount: 4,
                                                crossAxisSpacing: 4.0,
                                                mainAxisSpacing: 4.0),
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                            child: Column(
                                              children: [
                                                SelectableImage(
                                                  isSelected:
                                                      selectedCard == index,
                                                  imageNetwork: _images[index],
                                                  onTap: (imageNetwork) {
                                                    setState(() {
                                                      selectedCard = index;
                                                    });
                                                  },
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Pop Corn',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      ),
                                      Center(
                                        child: ElevatedButton(
                                          child: Text("Button"),
                                          onPressed: () {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ));
                          },
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
