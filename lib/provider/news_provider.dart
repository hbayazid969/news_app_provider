import 'package:flutter/cupertino.dart';
import 'package:news_app_provider/model/news_model.dart';
import 'package:news_app_provider/service/news_api.dart';
import 'package:provider/provider.dart';

class NewsProvider with ChangeNotifier {
  List<Articles> newsList = [];

  Future<List<Articles>> getNewsData(
      {required int page, required String sortBy}) async {
    newsList = await NewsApiService.fetchnewsData(pages: page, sortBy: sortBy);
    return newsList;
  }
}
