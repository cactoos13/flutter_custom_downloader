import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:custom_downloader/downloadable_item_stfl.dart';

import 'downloadable_model.dart';

class MyHomePageSTFL extends StatefulWidget {
  @override
  _MyHomePageSTFLState createState() => _MyHomePageSTFLState();
}

class _MyHomePageSTFLState extends State<MyHomePageSTFL> {
  List<int> progressList = [];
  List<Downloadable> downloadables = [];
  bool _hasPermission = true;
  String _localPath;
  bool _directoryExists = false;

  @override
  void initState() {
    downloadables = [
      Downloadable(title: '1', url: 'https://file-examples.com/wp-content/uploads/2017/10/file-sample_150kB.pdf',),
      Downloadable(title: '2', url: 'https://file-examples.com/wp-content/uploads/2017/10/file-example_PDF_500_kB.pdf'),
      Downloadable(title: '3', url: 'https://file-examples.com/wp-content/uploads/2017/10/file-example_PDF_1MB.pdf'),
//      Downloadable(title: '4', url: 'https://file-examples.com/wp-content/uploads/2017/10/file-sample_150kB.pdf'),
    ];
    downloadables.forEach((item) => print('item.fileName: ${item.fileName}'));
    progressList = List.generate(downloadables.length, (int index) => 0);
//    hasPermission = _checkPermission();
    _checkPermission();


//    Timer.periodic(Duration(seconds: 1), (timer) {
//      for (int i = 0; i < downloadables.length; i++) {
//        if (timer.tick % 4 == i)
//          increment(i);
//      }
//    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Custom Downloader'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
//          Map<PermissionGroup, PermissionStatus> permissions =
//              await PermissionHandler()
//                  .requestPermissions([PermissionGroup.storage]);
//          print(permissions);
          bool isOpened = await PermissionHandler().openAppSettings();
//          bool isShown = await PermissionHandler()
//              .shouldShowRequestPermissionRationale(PermissionGroup.storage);
          PermissionStatus permission = await PermissionHandler()
              .checkPermissionStatus(PermissionGroup.storage);
          print(permission);
        },
      ),
      body: Center(
        child: ListView.builder(
          itemCount: downloadables.length,
          itemBuilder: (BuildContext context, int index) {
            return DownloadableItemSTFL(
              key: UniqueKey(),
              downloadable: downloadables[index],
              id: index,
              deleteFunction: removeItem,
            );
          },
        ),
      ),
    );
  }


  void removeItem(int index) {
    setState(() {
      downloadables.removeAt(index);
    });
  }

  Future<bool> _checkPermission() async {
//    if (widget.platform == TargetPlatform.android) {
    PermissionStatus permission = await PermissionHandler()
        .checkPermissionStatus(PermissionGroup.storage);
    if (permission != PermissionStatus.granted) {
      Map<PermissionGroup, PermissionStatus> permissions =
      await PermissionHandler()
          .requestPermissions([PermissionGroup.storage]);
      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
        _hasPermission = true;
        return true;
      }
    } else {
      _hasPermission = true;
      return true;
    }
//    } else {
//      return true;
//    }
    _hasPermission = false;
    return false;
  }

  Future<void> _prepare() async {
    _localPath = (await _findLocalPath()) + '/Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (hasExisted) {
      print('exists');
      _directoryExists = true;
    } else {
      print('doesn\'t exists');
      _directoryExists = false;
      savedDir.create();
    }
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }
}
