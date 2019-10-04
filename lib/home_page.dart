import 'dart:async';

import 'downloadable_item.dart';
import 'downloadable_model.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> progressList = [];
  List<Downloadable> downloadables = [];

  @override
  void initState() {
    downloadables = [
      Downloadable(title: '1', url: '1'),
      Downloadable(title: '2', url: '2'),
      Downloadable(title: '3', url: '3'),
      Downloadable(title: '4', url: '4'),
    ];
    progressList = List.generate(downloadables.length, (int index) => 0);

    Timer.periodic(Duration(seconds: 1), (timer) {
      for (int i = 0; i < downloadables.length; i++) {
        if (timer.tick % 4 == i)
          increment(i);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Downloader'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: downloadables.length,
          itemBuilder: (BuildContext context, int index) {
            return DownloadableItem(
              downloadable: downloadables[index],
              id: index,
              progress: progressList[index],
              function: () {
                increment(index);
              },
            );
          },
        ),
      ),
    );
  }

  void increment(int index) {
    setState(() {
      progressList[index]++;
    });
  }

  void incrementAll() {
    for (int i = 0; i < downloadables.length; i++) {
      increment(i);
    }
  }

  void incrementInOrder() {
    for (int i = 0; i < downloadables.length; i++) {
      increment(i);
    }
  }
}
