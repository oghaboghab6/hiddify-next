import 'dart:io';

import 'package:path/path.dart' as p;

class ProfilePathResolver {
  const ProfilePathResolver(this._workingDir);

  final Directory _workingDir;

  Directory get directory => Directory(p.join(_workingDir.path, "configs"));

  File file(String fileName) {
    return File(p.join(directory.path, "$fileName.json"));
  }
  File fileAll() {
    // final dir = Directory(directory.path);
    //directory.deleteSync(recursive: true);
    directory.list(recursive: false).forEach((file) {
      String fileName = file.path.split('/').last;
      if (fileName.contains(".json")) file.deleteSync(recursive: true);
    });
    return File(p.join(directory.path, "*.json"));
  }

  File tempFile(String fileName) => file("$fileName.tmp");
}
