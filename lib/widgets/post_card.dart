// import 'package:almira_front_end/api/api-post-service.dart';
// import 'package:almira_front_end/screens/comments_screen.dart';
// import 'package:almira_front_end/screens/feed_screen.dart';
// import 'package:almira_front_end/utils/utils.dart' as utils;
// import 'package:almira_front_end/widgets/like_animation.dart';
// import 'package:flutter/material.dart';

// class PostCard extends StatefulWidget {
//   final snap;

//   const PostCard({Key? key, required this.snap}) : super(key: key);

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   @override
//   void initState() {
//     widget.snap;
//     super.initState();
//   }

//   bool isLikeAnimating = false;

//   @override
//   Widget build(BuildContext context) {
//     late List listOfDataImage = widget.snap["image"];
//     final postImage = listOfDataImage[0];

//     return Container(
//       padding: const EdgeInsets.symmetric(
//         vertical: 10,
//       ),
//       child: Column(
//         children: [
//           //HEADER
//           Container(
//             padding: const EdgeInsets.symmetric(
//               vertical: 4,
//               horizontal: 16,
//             ).copyWith(right: 0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundImage: NetworkImage(
//                       widget.snap["user_data"]["user_image"]["image_url"]),
//                 ),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(
//                       left: 8,
//                     ),
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           widget.snap["user_data"]["nick_name"],
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     showDialog(
//                         context: context,
//                         builder: (context) => Dialog(
//                               backgroundColor: Colors.white,
//                               child: ListView(
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 16,
//                                 ),
//                                 shrinkWrap: true,
//                                 children: [
//                                   'Delete',
//                                 ]
//                                     .map((e) => InkWell(
//                                           onTap: () async {
//                                             await ApiPostService()
//                                                 .deletePost(
//                                                     widget.snap["post_id"])
//                                                 .then((value) async {
//                                               Navigator.of(context).pop();
//                                             }).catchError((error) {
//                                               ScaffoldMessenger.of(context)
//                                                   .showSnackBar(SnackBar(
//                                                       content: Text(
//                                                           error.toString())));
//                                             });
//                                           },
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 12,
//                                               vertical: 16,
//                                             ),
//                                             child: Text(e),
//                                           ),
//                                         ))
//                                     .toList(),
//                               ),
//                             ));
//                   },
//                   icon: const Icon(
//                     Icons.more_vert,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Image Section
//           GestureDetector(
//             onDoubleTap: () async {
//               await ApiPostService()
//                   .likePosts(widget.snap["post_id"], widget.snap["is_liked"])
//                   .catchError((error) {
//                 ScaffoldMessenger.of(context)
//                     .showSnackBar(SnackBar(content: Text(error.toString())));
//               });
//               setState(() {
//                 isLikeAnimating = true;
//               });
//             },
//             child: Stack(
//               alignment: Alignment.center,
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.35,
//                   width: double.infinity,
//                   child: Image.network(
//                     postImage["image_url"],
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 AnimatedOpacity(
//                   opacity: isLikeAnimating ? 1 : 0,
//                   duration: const Duration(milliseconds: 2000),
//                   child: LikeAnimation(
//                     child: const Icon(Icons.favorite,
//                         color: Colors.white, size: 120),
//                     isAnimating: isLikeAnimating,
//                     duration: const Duration(
//                       milliseconds: 400,
//                     ),
//                     onEnd: () {
//                       setState(() {
//                         isLikeAnimating = false;
//                       });
//                     },
//                   ),
//                 )
//               ],
//             ),
//           ),

//           //Like Comment

//           Row(
//             children: [
//               LikeAnimation(
//                 isAnimating: true,
//                 smallLike: true,
//                 child: IconButton(
//                   onPressed: () async {
//                     await ApiPostService()
//                         .likePosts(
//                             widget.snap["post_id"], widget.snap["is_liked"])
//                         .catchError((error) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text(error.toString())));
//                     });
//                   },
//                   icon: widget.snap["is_liked"]
//                       ? const Icon(Icons.favorite, color: Colors.red)
//                       : const Icon(Icons.favorite_border),
//                 ),
//               ),
//               IconButton(
//                   onPressed: () => Navigator.of(context).push(
//                         MaterialPageRoute(
//                           builder: (context) => CommentsScreen(
//                             postId: widget.snap['post_id'].toString(),
//                           ),
//                         ),
//                       ),
//                   icon: const Icon(Icons.comment_outlined)),
//               IconButton(onPressed: () {}, icon: const Icon(Icons.send)),
//               Expanded(
//                   child: Align(
//                 alignment: Alignment.bottomRight,
//                 child: IconButton(
//                   icon: const Icon(Icons.bookmark_border),
//                   onPressed: () {},
//                 ),
//               ))
//             ],
//           ),

//           //Number and comment

//           Container(
//             padding: const EdgeInsets.symmetric(
//               horizontal: 16,
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 DefaultTextStyle(
//                   style: Theme.of(context)
//                       .textTheme
//                       .subtitle2!
//                       .copyWith(fontWeight: FontWeight.w800),
//                   child: Text(
//                     '${widget.snap["like_count"]} likes',
//                     style: Theme.of(context).textTheme.bodyText2,
//                   ),
//                 ),
//                 Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(top: 8),
//                   child: RichText(
//                     text: TextSpan(
//                       style: TextStyle(
//                         color: Colors.black,
//                       ),
//                       children: [
//                         TextSpan(
//                           text: widget.snap["user_data"]["nick_name"],
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: ' ${widget.snap["content"]}',
//                         )
//                       ],
//                     ),
//                   ),
//                 ),

//                 //view comment

//                 InkWell(
//                   onTap: () {},
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       vertical: 6,
//                     ),
//                     child: Text(
//                       'View ${widget.snap["comment_count"]} comments ',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),

//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     vertical: 6,
//                   ),
//                   child: Text(
//                     widget.snap["created"],
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
