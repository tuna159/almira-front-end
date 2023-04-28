import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class RecommandUser extends StatefulWidget {
  const RecommandUser({Key? key}) : super(key: key);

  @override
  State<RecommandUser> createState() => _RecommandUserState();
}

class User {
  final String avatar;
  final String name;

  User({required this.name, required this.avatar});
}

class _RecommandUserState extends State<RecommandUser> {
  @override
  void initState() {
    super.initState();
  }

  final List<User> users = [
    User(
        avatar:
            'https://haycafe.vn/wp-content/uploads/2021/11/Anh-avatar-dep-chat-lam-hinh-dai-dien.jpg',
        name: 'anhtran1'),
    User(
        avatar:
            'https://img6.thuthuatphanmem.vn/uploads/2022/11/18/anh-avatar-don-gian-ma-dep_081757969.jpg',
        name: 'hong_vunb'),
    User(
        avatar:
            "https://i0.wp.com/thatnhucuocsong.com.vn/wp-content/uploads/2023/02/Hinh-anh-avatar-Facebook.jpg?ssl\u003d1",
        name: 'king_boy'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommand User'),
        backgroundColor: defaultColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Container(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 16,
                  ).copyWith(right: 8),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: (() {}),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundImage: NetworkImage(users[index].avatar),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      SizedBox(
                        width: 150,
                        child: Text(users[index].name),
                      ),
                      CustomButton(
                        text: 'Follow',
                        backgroundColor: defaultColor,
                        textColor: Colors.white,
                        borderColor: Colors.black,
                        function: () async {
                          setState(() {});
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),

      // FutureBuilder(
      //   future: ApiUserService().getAllFollowing(widget.uid),
      //   builder: (context, snapshot) {
      //     if (snapshot.hasError) {
      //       return Text("Something went wrong! $snapshot");
      //     } else if (snapshot.hasData) {
      //       final following = snapshot.data!;
      //       return buildListViewFollowing(following);
      //     } else {
      //       return const Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
    );
  }

  ListView buildListViewFollowing(List listFollowing) {
    return ListView.builder(
      itemCount: listFollowing.length,
      itemBuilder: (context, index) {
        final following = listFollowing[index];
        return Container(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 4,
                  horizontal: 16,
                ).copyWith(right: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              uid: following["user_id"],
                            ),
                          ),
                        );
                      }),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(following["avatar"]),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    SizedBox(
                      width: 150,
                      child: Text(following["nick_name"]),
                    ),
                    following["is_following"]
                        ? CustomButton(
                            text: 'Unfollow',
                            backgroundColor: Colors.white,
                            textColor: Colors.black,
                            borderColor: Colors.grey,
                            function: () async {
                              await ApiUserService()
                                  .unfollowUser(following["user_id"]);
                              setState(() {});
                            },
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
