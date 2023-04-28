import 'package:almira_front_end/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Shop {
  final String background;
  final String name;

  Shop({required this.name, required this.background});
}

class ShopList extends StatelessWidget {
  final Uri _url = Uri.parse('https://www.petmart.vn');
  final Uri _url1 = Uri.parse('https://kunmiu.vn/');
  final Uri _url2 = Uri.parse('https://www.petcity.vn/');

  final List<Shop> shops = [
    Shop(
        background:
            'https://www.petmart.vn/wp-content/uploads/2020/09/petmart-logo-trang.png',
        name: 'Pet Mart'),
    Shop(
        background:
            'https://toplist.vn/images/800px/kun-miu-pet-shop-1058632.jpg',
        name: 'Kún Miu Pet Shop'),
    Shop(
        background:
            'https://www.petcity.vn/media/lib/04-03-2022/logo-petcity-225x71.jpg',
        name: 'Petcity'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shops List'),
        backgroundColor: defaultColor,
      ),
      body: ListView.builder(
        itemCount: shops.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: _launchUrl,
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

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
