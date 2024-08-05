import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_news_app/provider/news_provider.dart';
import 'package:weather_news_app/screen/countries.dart';
import 'package:weather_news_app/screen/countries_screen.dart';

import '../provider/weather_provider.dart';

class NewsScreen extends ConsumerStatefulWidget {
  const NewsScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  bool filtering = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(newsProvider.notifier).fetchHeadlines();
      ref.read(weatherProvider.notifier).currentWeatherData();
    });
  }

  void applyWeatherBasedFilter(String weatherCondition) {
    final filteredHeadlines =
        ref.read(newsProvider.notifier).filterHeadlines(weatherCondition);
    setState(() {
      ref.read(newsProvider.notifier).updateArticles(filteredHeadlines);
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    final weatherCondition = ref.watch(weatherProvider).getWeatherCondition();

    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                  child: const Text(
                    "Top's Headlines",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              Spacer(),
              filtering == false
                  ? InkWell(
                      child: Icon(Icons.filter_alt),
                      onTap: () {
                        filtering = true;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: Text(
                                'Current Weather News',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    filtering = false;
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (filtering) {
                                      applyWeatherBasedFilter(weatherCondition);
                                      ref.read(newsProvider).fetchHeadlines();
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : InkWell(
                      child: Icon(Icons.filter_alt_off),
                      onTap: () {
                        filtering = false;
                        newsState.filterArticles = '';
                        ref.read(newsProvider).fetchHeadlines();
                      },
                    ),
              Spacer(),
              InkWell(
                onTap: () async {
                  final countrycode = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountryScreen(),
                    ),
                  );
                  if (countrycode.toString().isNotEmpty) {
                    setState(() {
                      newsState.countryName = countrycode;
                      ref.read(newsProvider).fetchHeadlines();
                    });
                  }
                },
                child: Container(
                    margin: EdgeInsets.only(right: 20),
                    child: Row(
                      children: [
                        Image.network(
                          getFlagUrl(newsState.countryName),
                          width: 35,
                          height: 35,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.keyboard_arrow_down)
                      ],
                    )),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount:
                  newsState.article == null ? 1 : newsState.article!.length,
              itemBuilder: (context, index) {
                if (newsState.article == null) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  final article = newsState.article?[index];
                  return GestureDetector(
                    onTap: () {
                      ref
                          .read(newsProvider)
                          .launchUrlLink(article.url.toString());
                    },
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            margin: const EdgeInsets.only(bottom: 10),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                article!.urlToImage.toString(),
                                fit: BoxFit.fill,
                                width: double.infinity,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Image.asset(
                                    'images/news_image.jpg',
                                    fit: BoxFit.fill,
                                    width: double.infinity,
                                  );
                                },
                              ),
                            ),
                          ),
                          Text(
                            article.author ?? 'Unknown Source',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            article.title ?? 'No description available',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              '- ${article.publishedAt}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
