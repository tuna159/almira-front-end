import 'package:almira_front_end/api/api-activity-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
        title: const Text('Notifications'),
        automaticallyImplyLeading: false,
        backgroundColor: defaultColor,
      ),
      body: Center(
        child: FutureBuilder(
          future: ApiActivityService().getActivity(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! $snapshot");
            } else if (snapshot.hasData) {
              final activity = snapshot.data!;
              return buildListViewActivity(activity);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ListView buildListViewActivity(List listOfData) {
    return ListView.builder(
      itemCount: listOfData.length,
      itemBuilder: (context, index) {
        final acvities = listOfData[index];
        listOfDataImage = acvities["post_image"];
        final postImage = listOfDataImage[0];
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
                      backgroundImage:
                          NetworkImage(acvities["image"]["image_url"]),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              acvities["summary"],
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      child: Image.network(
                        postImage["image_url"],
                        fit: BoxFit.cover,
                      ),
                    )
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
