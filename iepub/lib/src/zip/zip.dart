import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:iepub/src/log/log.dart';

class IZip {
  IZip._();

  /// 解压epub文件
  static Future<void> decoder(
    List<int> data,
    String outDir, {
    bool verify = false,
    String? password,
  }) async {
    Directory directory = Directory(outDir);
    bool isExists = await directory.exists();
    if (!isExists) {
      await directory.create(recursive: true);
    }
    final archive = ZipDecoder().decodeBytes(
      data,
      verify: verify,
      password: password,
    );
    for (var file in archive.files) {
      if (file.isFile) {
        final outputStream = OutputFileStream('${directory.path}/${file.name}');
        file.writeContent(outputStream);
        outputStream.close();
        Iogger.d('解压获取文件: ${file.name}');
      }
    }
  }
}
