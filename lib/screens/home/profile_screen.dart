import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/screens/header/message_detail_page.dart';
import 'package:almira_front_end/screens/profile/edit_profile.dart';
import 'package:almira_front_end/screens/profile/list_follower.dart';
import 'package:almira_front_end/screens/profile/list_following.dart';
import 'package:almira_front_end/screens/profile/update-password.dart';
import 'package:almira_front_end/screens/profile/voucher_list.dart';
import 'package:almira_front_end/screens/welcome-app/welcome.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/enum.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:almira_front_end/widgets/custom_button.dart';
import 'package:flutter/cupertino.dart';
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
              title: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    snap["user_name"],
                    style:
                        TextStyle(fontSize: 20, fontFamily: 'OpenSansMedium'),
                  )),
              leading: FutureBuilder(
                  future: uid(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong! $snapshot");
                    } else if (snapshot.hasData) {
                      return snapshot.data!
                          ? Container()
                          : IconButton(
                              icon: const Icon(Icons.arrow_back_outlined),
                              onPressed: () {
                                Navigator.pop(context, "refresh");
                              },
                            );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
              actions: [
                FutureBuilder(
                    future: uid(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text("Something went wrong! $snapshot");
                      } else if (snapshot.hasData) {
                        if (snapshot.data! == false) {
                          return PopupMenuButton<MenuItems>(
                            onSelected: (value) async {
                              if (value == MenuItems.itemLogout) {
                                showMyDialogBlockUser();
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: MenuItems.itemBlock,
                                child: ListTile(
                                  leading: Icon(Icons.block_sharp),
                                  title: Text('Block '),
                                ),
                              ),
                              const PopupMenuItem(
                                value: MenuItems.itemUnblock,
                                child: ListTile(
                                  leading: Icon(Icons.block),
                                  title: Text('Unblock '),
                                ),
                              ),
                            ],
                          );
                        } else {
                          return PopupMenuButton<MenuItems>(
                            onSelected: (value) async {
                              if (value == MenuItems.itemLogout) {
                                showMyDialogLogout();
                              }
                              if (value == MenuItems.itemUpdatePassword) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const UpdatePassword(),
                                  ),
                                );
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: MenuItems.itemLogout,
                                child: ListTile(
                                  leading: Icon(Icons.logout),
                                  title: Text('Logout '),
                                ),
                              ),
                              const PopupMenuItem(
                                value: MenuItems.itemUpdatePassword,
                                child: ListTile(
                                  leading: Icon(Icons.password),
                                  title: Text('Update Password '),
                                ),
                              ),
                            ],
                          );
                        }
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })
              ],
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
                                    buildStatColumn(postLen, "posts", () {}),
                                    buildStatColumn(followers, "followers", () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowerList()));
                                    }),
                                    buildStatColumn(following, "following", () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  FollowingList()));
                                    }),
                                  ],
                                ),
                                FutureBuilder(
                                  future: uid(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(
                                          "Something went wrong! $snapshot");
                                    } else if (snapshot.hasData) {
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          snapshot.data!
                                              ? CustomButton(
                                                  backgroundColor: defaultColor,
                                                  borderColor: Colors.grey,
                                                  text: "Edit Profile",
                                                  textColor: primaryColor,
                                                  function: () async {
                                                    String refresh = await Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => EditProfile(
                                                                avatar: snap[
                                                                    "avatar"],
                                                                userName: snap[
                                                                    "user_name"],
                                                                introduction: snap[
                                                                    "introduction"])));
                                                    if (refresh == "refresh") {
                                                      setState(() {});
                                                    }
                                                  },
                                                )
                                              : isFollowing
                                                  ? CustomButton(
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
                                                  : CustomButton(
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
                                                    ),
                                          snapshot.data!
                                              ? CustomButton(
                                                  text:
                                                      'Point : ${snap["total_points"]}',
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.black,
                                                  borderColor: Colors.grey,
                                                  function: () async {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return VoucherList();
                                                    }));
                                                  },
                                                )
                                              // RichText(
                                              //     text: const TextSpan(
                                              //       children: [
                                              //         TextSpan(
                                              //           text: "11",
                                              //           style: TextStyle(
                                              //             fontSize: 18,
                                              //             color: Colors.black,
                                              //           ),
                                              //         ),
                                              //         TextSpan(
                                              //             text: " Points",
                                              //             style: TextStyle(
                                              //               fontSize: 15,
                                              //               fontWeight:
                                              //                   FontWeight.w400,
                                              //               color: Colors.grey,
                                              //             )),
                                              //       ],
                                              //     ),
                                              //   )
                                              : CustomButton(
                                                  text: 'Message',
                                                  backgroundColor: Colors.white,
                                                  textColor: Colors.black,
                                                  borderColor: Colors.grey,
                                                  function: () async {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return MessageDetailPage(
                                                        uid: widget.uid,
                                                      );
                                                    }));
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
                          snap["introduction"],
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

  Column buildStatColumn(int num, String label, Function()? function) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 33,
          child: TextButton(
            onPressed: function,
            child: Text(
              num.toString(),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
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

  void blockUser() async {
    await ApiUserService().blockUser(widget.uid).then((value) async {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Successful block user')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
    setState(() {});
  }

  Future<void> showMyDialogBlockUser() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm '),
          // ignore: prefer_interpolation_to_compose_strings
          content: Text('Do you want block user'),
          actions: <Widget>[
            TextButton(
                onPressed: blockUser,
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                )),
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialogLogout() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm '),
          // ignore: prefer_interpolation_to_compose_strings
          content: Text('Do you want log out'),
          actions: <Widget>[
            TextButton(
                onPressed: logout,
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.green),
                )),
            TextButton(
              child: const Text('No', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void logout() async {
    await ApiUserService().logout().then((value) async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const Welcome(),
        ),
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Successful logout')));
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    });
    setState(() {});
  }
}
