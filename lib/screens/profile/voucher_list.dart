import 'package:almira_front_end/api/api-voucher-service.dart';
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
      body: Center(
        child: FutureBuilder(
          future: ApiVoucherService().getAllVoucher(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong! $snapshot");
            } else if (snapshot.hasData) {
              final voucher = snapshot.data!;
              return buildListViewVoucher(voucher);
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  ListView buildListViewVoucher(List listOfData) {
    return ListView.builder(
      itemCount: listOfData.length,
      itemBuilder: (BuildContext context, int index) {
        final voucher = listOfData[index];
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedVoucher = voucher["code"];
            });
          },
          child: Card(
            child: ListTile(
              title: Text(voucher["voucher_name"]),
              subtitle: Container(
                child: Row(
                  children: [
                    Text(
                        "Expires after ${voucher["voucher_expiration_time"]} hours"),
                  ],
                ),
              ),
              leading: _selectedVoucher == voucher["code"]
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
    );
  }
}
