import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FollowingList extends StatefulWidget {
  final String uid;
  const FollowingList({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  late List listFollowing;
  bool isFollowing = false;
  late bool isLoading;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FollowingList'),
        backgroundColor: defaultColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: FutureBuilder(
        future: ApiUserService().getAllFollowing(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! $snapshot");
          } else if (snapshot.hasData) {
            final following = snapshot.data!;
            return buildListViewFollowing(following);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
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
