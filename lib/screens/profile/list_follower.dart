import 'package:almira_front_end/api/api-activity-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class FollowingList extends StatefulWidget {
  const FollowingList({super.key});

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> {
  late Future futureActivity;
  late List listOfDataImage;

  @override
  void initState() {
    futureActivity = ApiActivityService().getActivity();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FollowingList'),
        backgroundColor: defaultColor,
      ),
      body: ListView.builder(
        itemCount: 10,
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
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                            "https://znews-photo.zingcdn.me/w660/Uploaded/qhj_yvobvhfwbv/2018_07_18/Nguyen_Huy_Binh1.jpg"),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("user_name"),
                      SizedBox(
                        width: 100,
                      ),
                      CustomButton(
                          backgroundColor: backgroundColor,
                          borderColor: Colors.black,
                          text: "follower",
                          textColor: Colors.white)
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
