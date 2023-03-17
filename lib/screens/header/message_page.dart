import 'package:almira_front_end/api/api-message-service.dart';
import 'package:almira_front_end/screens/header/message_detail_page.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message'),
        backgroundColor: defaultColor,
      ),
      body: Center(
        child: FutureBuilder(
          future: ApiMessageService().getListMessage(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! $snapshot");
            } else if (snapshot.hasData) {
              final message = snapshot.data!;
              return buildListViewMessage(message);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ListView buildListViewMessage(List listOfData) {
    return ListView.builder(
      itemCount: listOfData.length,
      padding: const EdgeInsets.only(top: 16),
      itemBuilder: (context, index) {
        final message = listOfData[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return MessageDetailPage(
                uid: message["user_id"],
              );
            }));
          },
          child: Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            NetworkImage(message["user_image"]["image_url"]),
                        maxRadius: 30,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                        child: Container(
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                message["user_name"],
                                style: TextStyle(fontSize: 16),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                message["last_message"],
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                    fontWeight: message["is_deleted"]
                                        ? FontWeight.bold
                                        : FontWeight.normal),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  message["created"],
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: true ? FontWeight.bold : FontWeight.normal),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
