import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';

class VoucherList extends StatefulWidget {
  @override
  _VoucherListState createState() => _VoucherListState();
}

class _VoucherListState extends State<VoucherList> {
  List<String> _vouchers = [
    'Voucher 1',
    'Voucher 2',
    'Voucher 3',
    'Voucher 4',
  ];

  String _selectedVoucher = '';

  void _deleteVoucher(String voucherId) {
    setState(() {
      _vouchers.remove(voucherId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vouchers'),
        backgroundColor: defaultColor,
      ),
      body: ListView.builder(
        itemCount: _vouchers.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedVoucher = _vouchers[index];
              });
            },
            child: Card(
              child: ListTile(
                title: Text(_vouchers[index]),
                subtitle: Container(
                  child: Row(
                    children: [
                      Text("111"),
                    ],
                  ),
                ),
                leading: _selectedVoucher == _vouchers[index]
                    ? Icon(Icons.check)
                    : null,
                trailing: IconButton(
                  icon: Icon(Icons.currency_exchange_outlined),
                  onPressed: () => _deleteVoucher(_vouchers[index]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
