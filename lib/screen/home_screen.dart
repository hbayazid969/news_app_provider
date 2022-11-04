import 'package:flutter/material.dart';
import 'package:news_app_provider/model/news_model.dart';
import 'package:news_app_provider/provider/news_provider.dart';
import 'package:news_app_provider/service/news_api.dart';
import 'package:news_app_provider/widget/constant.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Articles> newsList = [];
  String sortBy = SortNews.popularity.name;

  @override
  Widget build(BuildContext context) {
    final providerData = Provider.of<NewsProvider>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu),
        centerTitle: true,
        title: Text(
          'News App',
          style: myStyle(18, Colors.white),
        ),
        actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: w / 50, right: w / 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: h / 95,
                ),
                Text(
                  "All News",
                  style: myStyle(18, Colors.black),
                ),
                SizedBox(
                  height: h / 95,
                ),
                Container(
                  height: h * 0.05,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      pageschangerButton(
                          title: 'Prev',
                          ontap: () {
                            if (currentIndex == 1) {
                              currentIndex == 1;
                            } else
                              setState(() {
                                currentIndex--;
                              });
                          }),
                      Expanded(
                        child: ListView.builder(
                            itemCount: 5,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: MaterialButton(
                                  color: index + 1 == currentIndex
                                      ? Colors.green
                                      : Colors.white,
                                  minWidth: w * 0.03,
                                  onPressed: () {
                                    setState(() {
                                      currentIndex = index + 1;
                                    });
                                  },
                                  child: Text(
                                    '${index + 1}',
                                    style: myStyle(18, Colors.black),
                                  ),
                                ),
                              );
                            }),
                      ),
                      pageschangerButton(
                          title: 'Next',
                          ontap: () {
                            if (currentIndex == 5) {
                              currentIndex == 5;
                            } else
                              setState(() {
                                currentIndex++;
                              });
                          })
                    ],
                  ),
                ),
                DropdownButton<String>(
                    value: sortBy,
                    items: [
                      DropdownMenuItem(
                        child: Text(
                          "${SortNews.publishedAt.name}",
                          style: myStyle(18, Colors.black),
                        ),
                        value: SortNews.publishedAt.name,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "${SortNews.popularity.name}",
                          style: myStyle(18, Colors.black),
                        ),
                        value: SortNews.popularity.name,
                      ),
                      DropdownMenuItem(
                        child: Text(
                          "${SortNews.relevancy.name}",
                          style: myStyle(18, Colors.black),
                        ),
                        value: SortNews.relevancy.name,
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        sortBy = value!;
                      });
                    }),
                Container(
                    height: h,
                    child: FutureBuilder<List<Articles>>(
                      future: providerData.getNewsData(
                          page: currentIndex, sortBy: sortBy),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error'),
                          );
                        }
                        return ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 1,
                                child: Container(
                                  color: Colors.white24,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      '${snapshot.data![index].title}',
                                      style: myStyle(20, Colors.black),
                                    ),
                                  ),
                                ),
                              );
                            });
                      },
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton pageschangerButton({VoidCallback? ontap, String? title}) =>
      ElevatedButton(
          onPressed: ontap,
          child: Text(
            '$title',
            style: myStyle(20, Colors.white),
          ));
}

int currentIndex = 1;

enum SortNews { publishedAt, popularity, relevancy }
