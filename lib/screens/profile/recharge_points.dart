import 'package:almira_front_end/screens/profile/QRCode.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class Points {
  final int id;
  final String point;
  final String qrcode;

  Points({required this.id, required this.point, required this.qrcode});
}

class RechargePoints extends StatelessWidget {
  final List<Points> points = [
    Points(
        id: 1,
        point: '50.000 VNĐ = 500 points',
        qrcode:
            "https://firebasestorage.googleapis.com/v0/b/almira-filles.appspot.com/o/qrcode%2F1.jpg?alt=media&token=78b3a36a-2b1a-43df-abc1-9d7ecefb1326"),
    Points(
        id: 2,
        point: '100.000 VNĐ = 1000 points',
        qrcode:
            "https://firebasestorage.googleapis.com/v0/b/almira-filles.appspot.com/o/qrcode%2F2.jpg?alt=media&token=1dfbb73d-06f4-4e64-a6c8-57af33ef6fe3"),
    Points(
        id: 3,
        point: '200.000 VNĐ = 2000 points',
        qrcode:
            "https://firebasestorage.googleapis.com/v0/b/almira-filles.appspot.com/o/qrcode%2F3.jpg?alt=media&token=3d91ddf7-1d4e-41f8-a346-83a251dd4eda"),
    Points(
        id: 4,
        point: '500.000 VNĐ = 5000 points',
        qrcode:
            "https://firebasestorage.googleapis.com/v0/b/almira-filles.appspot.com/o/qrcode%2F4.jpg?alt=media&token=09106da4-327c-4565-953e-8a73a6eb3827"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recharge Points'),
        backgroundColor: defaultColor,
      ),
      body: ListView.builder(
        itemCount: points.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QRCode(qrcode: points[index].qrcode)));
            },
            child: Card(
              child: ListTile(
                title: Text('${points[index].point}'),
                trailing: IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                QRCode(qrcode: points[index].qrcode)));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
