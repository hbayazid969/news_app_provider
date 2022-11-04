import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app_provider/model/news_model.dart';

class NewsApiService {
  static Future<List<Articles>> fetchnewsData(
      {required int pages, required String sortBy}) async {
    List<Articles> newsList = [];
    var link = Uri.parse(
        'https://newsapi.org/v2/everything?q=bitcoin&apiKey=455dd61ff05441218ed86acffbe8a8c0&pageSize=10&page=$pages&sortBy=$sortBy');
    var response = await http.get(link);
    var data = jsonDecode(response.body);
    Articles articles;
    for (var i in data['articles']) {
      articles = Articles.fromJson(i);
      newsList.add(articles);
    }
    return newsList;
  }
}
