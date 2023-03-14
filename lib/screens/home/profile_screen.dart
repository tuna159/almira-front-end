import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:almira_front_end/widgets/follow_button.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int followers = 0;
  int following = 0;
  int postLen = 0;
  bool isFollowing = false;
  late bool isLoading;
  var snap;
  late List listImage;
  var image;

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  getUserData() async {
    setState(() {
      isLoading = true;
    });
    try {
      snap = await ApiUserService().getUserDetail(widget.uid);

      postLen = snap["post_count"];
      followers = snap['followers'];
      following = snap['following'];
      isFollowing = snap["is_following"];
      setState(() {});
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    setState(() {
      isLoading = true;
    });

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> uid() async {
    String token = await getTokenFromSF();
    String uid = await decrypToken(token);
    if (uid == widget.uid) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: defaultColor,
              title: Text(
                snap['user_name'],
              ),
              automaticallyImplyLeading: false,
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(
                              snap["avatar"].toString(),
                            ),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildStatColumn(postLen, "posts"),
                                    buildStatColumn(followers, "followers"),
                                    buildStatColumn(following, "following"),
                                  ],
                                ),
                                FutureBuilder(
                                  future: uid(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          "Something went wrong! $snapshot");
                                    } else if (snapshot.hasData) {
                                      print(snapshot.data!);
                                      print(isFollowing);
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          snapshot.data!
                                              ? FollowButton(
                                                  backgroundColor: defaultColor,
                                                  borderColor: Colors.grey,
                                                  text: "Edit Profile",
                                                  textColor: primaryColor,
                                                  function: () {},
                                                )
                                              : isFollowing
                                                  ? FollowButton(
                                                      text: 'Unfollow',
                                                      backgroundColor:
                                                          Colors.white,
                                                      textColor: Colors.black,
                                                      borderColor: Colors.grey,
                                                      function: () async {
                                                        await ApiUserService()
                                                            .unfollowUser(
                                                                widget.uid);
                                                        setState(() {
                                                          isFollowing = false;
                                                          followers--;
                                                        });
                                                      },
                                                    )
                                                  : FollowButton(
                                                      text: 'Follow',
                                                      backgroundColor:
                                                          defaultColor,
                                                      textColor: Colors.white,
                                                      borderColor: Colors.black,
                                                      function: () async {
                                                        await ApiUserService()
                                                            .followUser(
                                                                widget.uid);
                                                        setState(() {
                                                          isFollowing = true;
                                                          followers++;
                                                        });
                                                      },
                                                    )
                                        ],
                                      );
                                    } else {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    }
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 15,
                        ),
                        child: Text(
                          snap["user_name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(
                          top: 1,
                        ),
                        child: Text(
                          "bio",
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                FutureBuilder(
                  future: ApiUserService().getUserDetail(widget.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong! $snapshot");
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final posts = data["post"];
                      late List listPost = posts;

                      return GridView.builder(
                        shrinkWrap: true,
                        itemCount: listPost.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          final post = listPost[index];
                          late List listOfDataImage = post["image"];
                          final postImage = listOfDataImage[0];
                          return Image(
                            image: NetworkImage(postImage['image_url']),
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
