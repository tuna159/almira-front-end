import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class QRCode extends StatefulWidget {
  final qrcode;
  const QRCode({Key? key, required this.qrcode}) : super(key: key);

  @override
  State<QRCode> createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recharge Points'),
          backgroundColor: defaultColor,
        ),
        body: Center(
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            width: double.infinity,
            child: Image.network(
              widget.qrcode.toString(),
              fit: BoxFit.cover,
            ),
          ),
        ));
  }
}
