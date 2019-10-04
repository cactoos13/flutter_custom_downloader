import 'package:path/path.dart' as p;

class Downloadable {
  String url;
  String title;
  String fileName;

  Downloadable({String url, String title}) {
    this.url = url;
    this.title = title;
    this.fileName = p.basename(url).toString();
  }
//  int progress;

}
