import 'dart:async';
import 'dart:io';

import 'package:custom_downloader/downloadable_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class DownloadableItemSTFL extends StatefulWidget {
  final Function deleteFunction;
  final Downloadable downloadable;
  final int id;

  const DownloadableItemSTFL({
    this.deleteFunction,
    this.downloadable,
    this.id,
    Key key,
  }) : super(key: key);

  @override
  _DownloadableItemState createState() => _DownloadableItemState();
}

class _DownloadableItemState extends State<DownloadableItemSTFL> {
  double progress = 0;
//  Timer timer;

//  bool _permissionReady = true;
  bool _exists = false;
  bool _downloading = false;
  String _localPath;
  String _filePath;
  Dio dio;

  @override
  void initState() {
    super.initState();
    dio = Dio();
//    _isLoading = true;
//    _permissisonReady = false;
    _prepare();
  }

  @override
  void dispose() {
//    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(widget.downloadable.title),
        trailing: _exists
            ? IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  deleteFile();
//                  final dir = Directory(dirPath);
//                  dir.deleteSync(recursive: true);
                },
              )
            : Icon(Icons.file_download),
//        title: Text(progress.toString()),
        subtitle: !_downloading
            ? Container()
            : LinearProgressIndicator(
//          value: progress / 100,
                value: progress,
              ),
//        onTap: widget.function,
        onTap: () {
//          startTimer();
          if (_exists) {
            print('open');
            OpenFile.open(_filePath);
          } else {
            print('download');
            download(dio, widget.downloadable.url, _filePath
//                '$_localPath/${widget.downloadable.fileName}'
                );
          }
        },
      ),
    );
  }

  void deleteFile() {
//    widget.deleteFunction(widget.id);
    File(_filePath).delete();
    setState(() {
      _exists = false;
    });
  }

//  void startTimer() {
//    if (timer != null && timer.isActive) {
//      setState(() {
//        progress = 0;
//      });
//      timer.cancel();
//    }
//    timer = Timer.periodic(Duration(seconds: 1), (timer) {
//      increment();
//      //            print(timer.tick);
//    });
//  }

  void increment() {
    setState(() {
      if (progress < 100) progress++;
    });
  }

  Future download(Dio dio, String url, savePath) async {
//    print('in download');
    setState(() {
      _downloading = true;
    });
    try {
//      print('in try');
      await dio.download(
        url,
        savePath,
        onReceiveProgress: updateDownloadProgress,
      );
    } catch (e) {
      print(e);
    }
    setState(() {
      _downloading = false;
    });
  }

  Future<void> _prepare() async {
    _localPath = (await _findLocalPath()) + '/Download';
    _filePath = '$_localPath/${widget.downloadable.fileName}';

//    _localPath = (await _findLocalPath()) + '/Download/testFile.pdf';
//    final savedDir = Directory(_localPath);
//    final savedDir = Directory('$_localPath/${widget.downloadable.fileName}');
//    bool hasExisted = await savedDir.exists();
    bool hasExisted = await File(_filePath).exists();
    if (hasExisted) {
      print('exists');
      if(mounted) {
        setState(() {
          _exists = true;
        });
      }
    } else {
      print('doesn\'t exists');
      if(mounted) {
        setState(() {
          _exists = false;
        });
      }
//      savedDir.create();
    }
//    setState(() {
//      _isLoading = false;
//    });
  }

  Future<String> _findLocalPath() async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

//  Future<bool> _checkPermission() async {
////    if (widget.platform == TargetPlatform.android) {
//    PermissionStatus permission = await PermissionHandler()
//        .checkPermissionStatus(PermissionGroup.storage);
//    if (permission != PermissionStatus.granted) {
//      Map<PermissionGroup, PermissionStatus> permissions =
//          await PermissionHandler()
//              .requestPermissions([PermissionGroup.storage]);
//      if (permissions[PermissionGroup.storage] == PermissionStatus.granted) {
//        return true;
//      }
//    } else {
//      return true;
//    }
////    } else {
////      return true;
////    }
//    return false;
//  }

  void updateDownloadProgress(received, total) {
    print('in show progress');
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
      setState(() {
        progress = received / total;
        if (received == total) {
//          setState(() {
          _downloading = true;
          _exists = true;
        }
//          });
      });
    }
  }
}
