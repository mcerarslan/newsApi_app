
import 'package:flutter/material.dart';
import 'package:news_app/viewmodel/article_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/category.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  List<Category> categories = [
    Category('business', 'İş'),
    Category('entertainment', 'Eğlence'),
    Category('general', 'Genel'),
    Category('health', 'Sağlık'),
    Category('science', 'Bilim'),
    Category('sports', 'Spor'),
    Category('technology', 'Teknoloji'),
  ];

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ArticleListViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Gündemdeki Haberler"),centerTitle: true,),
      body: Column(
        children: [
          const SizedBox(height: 10,),
          SizedBox(
            height: 55,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: getCategoriesTab(vm),
            ),
          ),
          getWidgetByStatus(vm),
        ],
      ),
    );
  }

  List<GestureDetector> getCategoriesTab(ArticleListViewModel vm) {
    List<GestureDetector> list = [];
    for (int i=0; i < categories.length; i++) {
      list.add(GestureDetector(
        onTap: ()=>vm.getNews(categories[i].key),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Card(child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(categories[i].title,style: TextStyle(fontSize: 16),),
          )),
        ),
      ));
    }
    return list;
  }

  Widget getWidgetByStatus(ArticleListViewModel vm) {
    switch (vm.status.index) {
      case 2:
        return Expanded(
          child: ListView.builder(
              itemCount: vm.viewModel.articles.length,
              itemBuilder: (context,index){
                return Card(
                  child: Column(
                    children: [
                      Image.network(vm.viewModel.articles[index].urlToImage ?? 'https://t4.ftcdn.net/jpg/04/73/25/49/360_F_473254957_bxG9yf4ly7OBO5I0O5KABlN930GwaMQz.jpg' ),
                      ListTile(
                        title:
                        Text(vm.viewModel.articles[index].title ?? '',style: TextStyle(fontWeight: FontWeight.bold,),),
                        subtitle:  Text(vm.viewModel.articles[index].description ?? ''),
                      ),
                      ButtonBar(
                        children: [
                          MaterialButton(onPressed: () async {
                            await launchUrl(Uri.parse(vm.viewModel.articles[index].url ?? ''));
                          },
                            child: Text('Habere Git',style: TextStyle(color: Colors.blue),),
                          ),
                        ],
                      ),
                    ],
                  ),
                ); // Card Değişkeni içinde Haber Verilerin kurulduğu alanlar mevcut
              }),
        );
      default:
        return const Center(child: CircularProgressIndicator(),);
    }
  }
}
