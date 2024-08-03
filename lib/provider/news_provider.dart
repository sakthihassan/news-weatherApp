import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../model/newsHeadLine.dart';
import '../model/weather_model.dart';

class NewsProvider extends ChangeNotifier {
  final dio = Dio();

  List<Articles>? article = [];
  bool _isLoading = false;
  var countryName = "in";
  var categoryName = 'general';
  bool filterNews = false;

  Future<void> fetchHeadlines() async {
    try {
      final response = await dio.get(
        "https://newsapi.org/v2/top-headlines?country=$countryName&category=$categoryName&apiKey=ff2a5193d4ff4e4d875e6fd4f2c21c60",
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final newHeadlinesModel = NewsHeadLine.fromJson(data);
        article = newHeadlinesModel.articles;
        notifyListeners();
      } else {
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }


  Future<void> launchUrlLink(String url) async {
    _isLoading = true;

    try {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.inAppWebView,
      );
    } catch (e) {
      // Handle error if needed
    } finally {
      _isLoading = false;
    }
    notifyListeners();
  }

  List<Articles> filterHeadlines(String weatherCondition) {
    List<Articles> filteredArticles = [];
    switch (weatherCondition) {
      case 'cold':
        filteredArticles = article?.where((a) => a.title?.contains('depressing') ?? false).toList() ?? [];
        break;
      case 'hot':
        filteredArticles = article?.where((a) => a.description?.contains('fear') ?? false).toList() ?? [];
        break;
      case 'cool':
        filteredArticles = article?.where((a) => a.title?.contains('winning') ?? false || a.title!.contains('happiness') ?? false).toList() ?? [];
        break;
      default:
        filteredArticles = article ?? [];
        break;
    }
    return filteredArticles;
  }

  void updateArticles(List<Articles> articles) {
    this.article = articles;
    notifyListeners();
  }
}

final newsProvider = ChangeNotifierProvider<NewsProvider>((ref) => NewsProvider());
