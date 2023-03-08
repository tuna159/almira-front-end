// import 'package:almira_front_end/api/api-post-service.dart';
// import 'package:almira_front_end/widgets/post_card.dart';
// import 'package:flutter/material.dart';
// import 'package:almira_front_end/utils/utils.dart' as utils;

// class FeedScreen extends StatefulWidget {
//   const FeedScreen({Key? key}) : super(key: key);

//   @override
//   State<FeedScreen> createState() => _FeedScreenState();
// }

// class _FeedScreenState extends State<FeedScreen> {
//   //

//   late List listOfData;

//   @override
//   void initState() {
//     ApiPostService().getPost();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Almira'),
//         automaticallyImplyLeading: false,
//         backgroundColor: utils.defaulColor,
//         titleTextStyle: utils.getProgressHeaderStyle(),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.messenger_outline_sharp),
//             tooltip: 'Show Snackbar',
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('This is a snackbar')));
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder(
//         future: ApiPostService().getPost(),
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Text("Something went wrong! ${snapshot}");
//           } else if (snapshot.hasData) {
//             listOfData = snapshot.data!;
//             return ListView.builder(
//               itemCount: listOfData.length,
//               itemBuilder: (ctx, index) => PostCard(
//                 snap: listOfData[index],
//               ),
//             );
//           } else {
//             return Center(child: CircularProgressIndicator());
//           }
//         },
//       ),
//     );
//   }
// }
