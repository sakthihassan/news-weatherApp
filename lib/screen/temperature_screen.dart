import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_news_app/provider/weather_provider.dart';

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
                  groupValue:weatherState.temperature,
                  onChanged: (String? value) {
                    setState(() {
                      weatherState.temperature = value.toString();
                      weatherState.celsius = true;
                      ref.read(weatherProvider).currentWeatherData();
                      ref.read(weatherProvider).countryWeatherData();
                      ref.read(weatherProvider).countryLocForeCast();
                      ref.read(weatherProvider).currentLocForeCast();


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
                      ref.read(weatherProvider).currentWeatherData();
                      ref.read(weatherProvider).countryWeatherData();
                      ref.read(weatherProvider).countryLocForeCast();
                      ref.read(weatherProvider).currentLocForeCast();

                    });
                  },
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
