import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_news_app/screen/countries.dart';

class CountryScreen extends ConsumerStatefulWidget {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends ConsumerState<CountryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Countries"),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.pop(context, countries[index]['code']);
            },
            child: ListTile(
              leading: Image.network(
                  getFlagUrl(
                    countries[index]['code'],
                  ),
                  height: 35,
                  width: 35),
              title: Text(countries[index]['name']),
            ),
          );
        },
        itemCount: countries.length,
      ),
    );
  }
}
