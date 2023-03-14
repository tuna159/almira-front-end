import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/api/api-user-service.dart';
import 'package:almira_front_end/screens/home/profile_screen.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

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
                    searchUser = snapshot.data!;
                    final user = searchUser[index]!;
                    return InkWell(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            uid: user!["user_id"]!,
                          ),
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                            user!['image_url']!,
                          ),
                          radius: 16,
                        ),
                        title: Text(
                          user['user_name'],
                        ),
                        // ),
                      ),
                    );
                  },
                );
              },
            )
          : FutureBuilder(
              future: ApiPostService().getPost(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StaggeredGridView.countBuilder(
                  crossAxisCount: 3,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final posts = snapshot.data!;
                    late List listOfData = posts;
                    final post = listOfData[index];
                    late List listOfDataImage = post["image"];
                    final postImage = listOfDataImage[0];
                    return Image.network(
                      (postImage['image_url']),
                      fit: BoxFit.cover,
                    );
                  },
                  staggeredTileBuilder: (index) => StaggeredTile.count(
                      (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                );
              },
            ),
    );
  }
}
