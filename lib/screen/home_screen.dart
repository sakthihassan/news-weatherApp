import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_news_app/provider/news_provider.dart';
import 'package:weather_news_app/screen/news_screen.dart';
import 'package:weather_news_app/screen/setting_screen.dart';
import 'package:weather_news_app/screen/weather_screen.dart';

import '../provider/weather_provider.dart'; // Import your new screen

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _showNewsScreen = true;
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsProvider.notifier).fetchHeadlines();
      ref.read(weatherProvider.notifier).currentWeatherData();
      ref.read(weatherProvider.notifier).getUserLocation();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 50), // Placeholder for spacing
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "News",
                        style: TextStyle(fontSize: 30, color: Color(0xFF009087)),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "&",
                        style: TextStyle(fontSize: 30, color: Colors.grey.shade700),
                      ),
                      SizedBox(width: 5),
                      Text(
                        "Weather",
                        style: TextStyle(fontSize: 30, color: Color(0xFFFFD573)),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Row(
                      children: [

                        SizedBox(width: 15),
                        InkWell(child: Icon(Icons.settings),onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SettingScreen(),));
                        },),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _showNewsScreen ? NewsScreen() : WeatherScreen(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 5.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: FaIcon(FontAwesomeIcons.newspaper),
                onPressed: () {
                  setState(() {
                    _showNewsScreen = true; // Show NewsScreen
                  });
                },
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.cloudSun),
                onPressed: () {
                  setState(() {
                    _showNewsScreen = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
