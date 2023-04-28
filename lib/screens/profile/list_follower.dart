import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class FollowerList extends StatefulWidget {
  final String uid;
  const FollowerList({Key? key, required this.uid}) : super(key: key);

  @override
  State<FollowerList> createState() => _FollowerListState();
}

class _FollowerListState extends State<FollowerList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FollowerList'),
        backgroundColor: defaultColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ),
      body: FutureBuilder(
        future: ApiUserService().getAllFollower(widget.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong! $snapshot");
          } else if (snapshot.hasData) {
            final follower = snapshot.data!;
            return buildListViewFollower(follower);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ListView buildListViewFollower(List listFollower) {
    return ListView.builder(
      itemCount: listFollower.length,
      itemBuilder: (context, index) {
        final follower = listFollower[index];
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
                              uid: follower["user_id"],
                            ),
                          ),
                        );
                      }),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(follower["avatar"]),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(follower["nick_name"]),
                    ),
                    follower["is_following"]
                        ? IconButton(
                            onPressed: () {
                              showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) {
                                  return Dialog(
                                    child: ListView(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 16),
                                        shrinkWrap: true,
                                        children: [
                                          'Delete',
                                        ]
                                            .map(
                                              (e) => InkWell(
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                    child: Text(e),
                                                  ),
                                                  onTap: () async {
                                                    await ApiUserService()
                                                        .unfollowerUser(
                                                            follower["user_id"])
                                                        .then((value) {
                                                      setState(() {});
                                                      Navigator.pop(
                                                          context, true);
                                                    });
                                                  }),
                                            )
                                            .toList()),
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.more_vert),
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
