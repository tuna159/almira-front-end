import 'package:almira_front_end/model/shop.dart';
import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopList extends StatelessWidget {
  final List<Shop> shops = [
    Shop(
        background:
            'https://www.petmart.vn/wp-content/uploads/2020/09/petmart-logo-trang.png',
        name: 'Pet Mart',
        url: Uri.parse('https://www.petmart.vn')),
    Shop(
        background:
            'https://toplist.vn/images/800px/kun-miu-pet-shop-1058632.jpg',
        name: 'Kún Miu Pet Shop',
        url: Uri.parse('https://kunmiu.vn/')),
    Shop(
        background:
            'https://www.petcity.vn/media/lib/04-03-2022/logo-petcity-225x71.jpg',
        name: 'Petcity',
        url: Uri.parse('https://www.petcity.vn/'))
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shops List'),
        backgroundColor: defaultColor,
      ),
      body: ListView.builder(
        itemCount: shops.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () async {
              if (!await launchUrl(shops[index].url)) {
                throw Exception('Could not launch ${shops[index].url}');
              }
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 16,
                    ).copyWith(right: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          height: 100,
                          width: 200,
                          child: Image.network(
                            shops[index].background,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shops[index].name,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
