import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/news_provider.dart';

class NewscateogryScreen extends ConsumerStatefulWidget {
  const NewscateogryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NewscateogryScreen> createState() => _NewscateogryScreenState();
}

class _NewscateogryScreenState extends ConsumerState<NewscateogryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    final newsState = ref.watch(newsProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("News Cateogry"),
        centerTitle: true,
      ),
      body: Column(
        children: [
                    Expanded(
            child: ListView(
              children: [
                RadioListTile<String>(
                  title: const Text('General'),
                  value: 'general',
                  groupValue: newsState.categoryName,
                  onChanged: (String? value) {
                    setState(() {
                      newsState.categoryName = value.toString();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(newsProvider).fetchHeadlines();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Business'),
                  value: 'business',
                  groupValue: newsState.categoryName,
                  onChanged: (String? value) {
                    setState(() {
                      newsState.categoryName = value.toString();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(newsProvider).fetchHeadlines();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Entertainment'),
                  value: 'entertainment',
                  groupValue: newsState.categoryName,
                  onChanged: (String? value) {
                    setState(() {
                      newsState.categoryName = value.toString();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(newsProvider).fetchHeadlines();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Health'),
                  value: 'health',
                  groupValue: newsState.categoryName,
                  onChanged: (String? value) {
                    setState(() {
                      newsState.categoryName = value.toString();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(newsProvider).fetchHeadlines();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Science'),
                  value: 'science',
                  groupValue: newsState.categoryName,
                  onChanged: (String? value) {
                    setState(() {
                      newsState.categoryName = value.toString();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(newsProvider).fetchHeadlines();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Sports'),
                  value: 'sports',
                  groupValue: newsState.categoryName,
                  onChanged: (String? value) {
                    setState(() {
                      newsState.categoryName = value.toString();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(newsProvider).fetchHeadlines();
                    });
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Technology'),
                  value: 'technology',
                  groupValue: newsState.categoryName,
                  onChanged: (String? value) {
                    setState(() {
                      newsState.categoryName = value.toString();
                      Navigator.pop(context);
                      Navigator.pop(context);
                      ref.read(newsProvider).fetchHeadlines();
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
