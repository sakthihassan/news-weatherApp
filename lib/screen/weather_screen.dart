import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:weather_news_app/model/forecast_model.dart';
import 'package:weather_news_app/provider/weather_provider.dart';

TextEditingController searchCountry = TextEditingController();

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
  String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (searchCountry.text.isEmpty) {
        ref.read(weatherProvider).currentWeatherData();
        ref.read(weatherProvider).currentLocForeCast();
      } else {
        ref.read(weatherProvider).countryWeatherData();
        ref.read(weatherProvider).countryLocForeCast();
      }
    });
  }

  void updateDateTime(int timezoneOffset) {
    DateTime now =
        DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    setState(() {
      formattedDate = DateFormat('EEEE, d MMMM yyyy').format(now);
      formattedTime = DateFormat('hh:mm a').format(now);
    });
  }

  String formatDate(int dt) {
    final date = DateTime.fromMillisecondsSinceEpoch(dt * 1000);
    return DateFormat('d MMMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final weatherProviderState = ref.watch(weatherProvider);

    // Update date and time when weather data is available
    if (weatherProviderState.weatherData != null) {
      int timezoneOffset = weatherProviderState.weatherData!.timezone ?? 0;
      updateDateTime(timezoneOffset);
    }

    if (weatherProviderState.isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.blueAccent,
          ),
        ),
      );
    }

    List<ForecastList> dailyForecasts = [];
    Map<String, ForecastList> dailyMap = {};

    if (weatherProviderState.forecast.isNotEmpty) {
      final todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
      for (var forecast in weatherProviderState.forecast) {
        final date = DateTime.fromMillisecondsSinceEpoch(forecast.dt! * 1000);
        final dateKey = DateFormat('yyyy-MM-dd').format(date);

        if (!dailyMap.containsKey(dateKey) &&
            DateFormat('yyyy-MM-dd').format(date) != todayDate) {
          dailyMap[dateKey] = forecast;
        }
      }

      dailyForecasts = dailyMap.values.toList();
      print("DailyForCasts : ${dailyForecasts}");
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(
                top: 100.0, left: 20.0, right: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Weather Forecast",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                ),
                SizedBox(height: 16),
                if (weatherProviderState.weatherData != null) ...[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weatherProviderState.weatherData?.name ?? "No Data",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        weatherProviderState.celsius
                            ? "${weatherProviderState.kelvinToCelsius(weatherProviderState.weatherData?.main.temp ?? 0)}°C"
                            : "${weatherProviderState.kelvinToFahrenheit(weatherProviderState.weatherData?.main.temp ?? 0)}°F",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent,
                        ),
                      ),
                      Text(
                        weatherProviderState.weatherData?.weather[0].main ??
                            "No Data",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  if (weatherProviderState.weatherData?.weather[0].main ==
                      "Rain") ...{
                    Image.asset(
                      'images/rainy.jpeg',
                      height: 100,
                      width: 100,
                    )
                  } else ...{
                    Image.asset('images/cloudy.png', height: 100, width: 100)
                  },
                  SizedBox(height: 20),
                  Text(
                    "Next 5 Days Forecast",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey[700],
                    ),
                  ),
                  SizedBox(height: 10),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: dailyForecasts.length,
                    itemBuilder: (context, index) {
                      final forecast = dailyForecasts[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        DateFormat('EEEE').format(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                forecast.dt! * 1000)),
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[700],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        formatDate(forecast.dt ?? 0),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(forecast.weather!.first.main
                                          .toString())
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Center(
                                  child: Text(
                                    weatherProviderState.celsius
                                        ? "${weatherProviderState.kelvinToCelsius(forecast.main?.temp ?? 0)}°C"
                                        : "${weatherProviderState.kelvinToFahrenheit(forecast.main?.temp ?? 0)}°F",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: forecast.weather!.first.main == "Rain"
                                      ? Image.asset(
                                          'images/rainy.jpeg',
                                          height: 50,
                                          width: 50,
                                        )
                                      : Image.asset(
                                          'images/cloudy.png',
                                          height: 50,
                                          width: 50,
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                ] else ...[
                  Center(
                    child: Text(
                      "No weather data available",
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ),
                ],
              ],
            ),
          ),
          Positioned(
            top: 30,
            left: 20,
            right: 20,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                cursorColor: Color(0xFFFFD573),
                controller: searchCountry,
                decoration: InputDecoration(
                  hintText: "Search Country or City",
                  suffixIcon: InkWell(
                    child: Icon(Icons.search),
                    onTap: () {
                      setState(() {
                        if (searchCountry.text.isNotEmpty) {
                          weatherProviderState.countryName =
                              searchCountry.text.toString();
                          ref.read(weatherProvider).countryWeatherData();
                          ref.read(weatherProvider).countryLocForeCast();
                        }
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                ),
                onChanged: (text) {
                  if (text.isEmpty) {
                    ref.read(weatherProvider).getUserLocation();
                    ref.read(weatherProvider).currentWeatherData();
                    ref.read(weatherProvider).currentLocForeCast();
                    weatherProviderState.countryName = '';
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void dispose() {
    super.dispose();
  }
}
