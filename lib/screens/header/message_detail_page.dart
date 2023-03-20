import 'package:almira_front_end/api/api-message-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:flutter/material.dart';

class MessageDetailPage extends StatefulWidget {
  final String uid;

  const MessageDetailPage({
    Key? key,
    required this.uid,
  }) : super(key: key);

  @override
  State<MessageDetailPage> createState() => _MessageDetailPageState();
}

class _MessageDetailPageState extends State<MessageDetailPage> {
  String userName = '';
  String userImage = '';
  late bool isLoading;
  var snap;
  final TextEditingController _contentController = TextEditingController();
  ApiMessageService _apiMessageService = ApiMessageService();

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
      snap = await ApiMessageService().getListMessageDetail(widget.uid);

      userName = snap["user_data"]["user_name"];
      userImage = snap['user_data']["user_image"]["image_url"];
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

  @override
  void dispose() {
    super.dispose();
    _contentController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              backgroundColor: defaultColor,
              flexibleSpace: SafeArea(
                child: Container(
                  padding: EdgeInsets.only(right: 16),
                  child: Row(
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(userImage),
                        maxRadius: 20,
                      ),
                      const SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              userName,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.block,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            body: Stack(
              children: <Widget>[
                FutureBuilder(
                  future: ApiMessageService().getListMessageDetail(widget.uid),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong! $snapshot");
                    } else if (snapshot.hasData) {
                      final data = snapshot.data!;
                      final message = data["message_data"];
                      return buildListMessageDetail(message);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Row(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            height: 30,
                            width: 30,
                            decoration: BoxDecoration(
                              color: Colors.lightBlue,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: FloatingActionButton(
                              heroTag: "btn1",
                              onPressed: () {},
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 23,
                              ),
                              backgroundColor: defaultColor,
                              elevation: 0,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: TextField(
                            controller: _contentController,
                            decoration: const InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          heroTag: "btn2",
                          onPressed: () async {
                            await _apiMessageService
                                .addNewMessage(
                                    widget.uid, _contentController.text)
                                .then((value) {
                              setState(() {
                                _contentController.text = "";
                              });
                            }).catchError((error) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                  SnackBar(content: Text(error.toString())));
                            });
                          },
                          child: Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                          backgroundColor: defaultColor,
                          elevation: 0,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }

  ListView buildListMessageDetail(List listOfData) {
    return ListView.builder(
      itemCount: listOfData.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 10, bottom: 70),
      itemBuilder: (context, index) {
        final messagedetail = listOfData[index];
        return Container(
          padding:
              const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
          child: Align(
            alignment: (messagedetail["is_sent"]
                ? Alignment.topRight
                : Alignment.topLeft),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: (messagedetail["is_sent"]
                    ? Color.fromARGB(255, 101, 133, 238)
                    : Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                messagedetail["content"],
                style: const TextStyle(fontSize: 15),
              ),
            ),
          ),
        );
      },
    );
  }
}
