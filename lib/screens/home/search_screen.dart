import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  late List searchUser;

  @override
  void dispost() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: defaultColor,
          automaticallyImplyLeading: false,
          title: Form(
            child: TextFormField(
              controller: searchController,
              decoration: const InputDecoration(
                labelText: 'Search for a user...',
                labelStyle: TextStyle(color: Colors.black),
              ),
              onFieldSubmitted: (String _) {
                setState(() {
                  isShowUsers = true;
                });
                print(_);
              },
            ),
          ),
        ),
        body: isShowUsers
            ? FutureBuilder(
                future: ApiUserService().getUserName(searchController.text),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      // return InkWell(
                      //   onTap: () => Navigator.of(context).push(
                      //     MaterialPageRoute(
                      //       builder: (context) => ProfileScreen(
                      //         uid: (snapshot.data! as dynamic).docs[index]['uid'],
                      //       ),
                      //     ),
                      //   ),
                      searchUser = snapshot.data!;
                      final user = searchUser[index];
                      return user["user_name"]
                              .toLowerCase()
                              .contains(searchController.text)
                          ? ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  user['image_url'],
                                ),
                                radius: 16,
                              ),
                              title: Text(
                                user['user_name'],
                              ),
                              // ),
                            )
                          : Container();
                    },
                  );
                },
              )
            : Text("post"));
  }
}
