import 'package:custom_downloader/downloadable_model.dart';
import 'package:flutter/material.dart';

class DownloadableItem extends StatelessWidget {
  final Downloadable downloadable;

//  final String title;
  final int id;
  final int progress;
  final Function function;

  const DownloadableItem({
//    this.title,
    this.downloadable,
    this.id,
    this.progress,
    this.function,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(downloadable.title),
        title: Text(progress.toString()),
        onTap: function,
      ),
    );
  }
}
