import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_news_app/provider/weather_provider.dart';
import 'package:weather_news_app/screen/weather_screen.dart';

class TemperatureScreen extends ConsumerStatefulWidget {
  const TemperatureScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TemperatureScreen> createState() => _TemperatureScreenState();
}

class _TemperatureScreenState extends ConsumerState<TemperatureScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final weatherState = ref.read(weatherProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("Temperature"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                RadioListTile<String>(
                  title: const Text('Celsius'),
                  value: 'Celsius',
                  groupValue: weatherState.temperature,
                  onChanged: (String? value) {
                    setState(() {
                      weatherState.temperature = value.toString();
                      weatherState.celsius = true;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Fahrenheit'),
                  value: 'Fahrenheit',
                  groupValue: weatherState.temperature,
                  onChanged: (String? value) {
                    setState(() {
                      weatherState.temperature = value.toString();
                      weatherState.celsius = false;
                    });
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                Navigator.pop(context);
                if (searchCountry.text.isEmpty) {
                  ref.read(weatherProvider).getUserLocation();
                  ref.read(weatherProvider).currentWeatherData();
                } else {
                  ref.read(weatherProvider).countryWeatherData();
                }
              },
              child: Text("Save"),
            ),
          ),
        ],
      ),
    );
  }
}
