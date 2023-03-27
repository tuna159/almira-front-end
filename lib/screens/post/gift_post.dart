import 'package:almira_front_end/api/api-gift-service.dart';
import 'package:almira_front_end/api/api-post-service.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:almira_front_end/utils/utils.dart';
import 'package:almira_front_end/widgets/selectable_image.dart';
import 'package:flutter/material.dart';

class GiftsPost extends StatefulWidget {
  final postId;
  final uid;
  const GiftsPost({Key? key, required this.postId, required this.uid})
      : super(key: key);
  @override
  _GiftsPostState createState() => _GiftsPostState();
}

class _GiftsPostState extends State<GiftsPost> {
  // Set an int with value -1 since no card has been selected
  int selectedCard = -1;
  late List listOfGift;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: defaultColor,
        title: const Text(
          'Gift',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_outlined),
          onPressed: () {
            Navigator.pop(context, "refresh");
          },
        ),
        centerTitle: false,
      ),
      body: Container(
          child: Scrollbar(
        thickness: 3,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                FutureBuilder(
                  future: ApiGiftService().getAllGift(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Something went wrong! $snapshot");
                    } else if (snapshot.hasData) {
                      final gift = snapshot.data!;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: gift.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: 1,
                                crossAxisCount: 2,
                                crossAxisSpacing: 4.0,
                                mainAxisSpacing: 4.0),
                        itemBuilder: (BuildContext context, int index) {
                          listOfGift = gift;
                          final listG = listOfGift[index];
                          return Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                SelectableImage(
                                  isSelected: selectedCard == listG["gift_id"],
                                  imageNetwork: listG["gift_image"],
                                  onTap: (imageNetwork) {
                                    setState(() {
                                      selectedCard = listG["gift_id"];
                                    });
                                  },
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  listG["name"],
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                Center(
                  child: ElevatedButton(
                    child: Text(
                      "Send Gift",
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: defaultColor,
                    ),
                    onPressed: () async {
                      await ApiPostService()
                          .sendGiftPost(widget.postId, widget.uid, selectedCard)
                          .then((value) {
                        Navigator.pop(context);
                        showSnackBar(
                          this.context,
                          'Successful Gift Giving',
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(error.toString())));
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
