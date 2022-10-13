/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-13 13:27:54
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 23:08:20
 * @FilePath: /iepub/lib/src/parse/xml.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'dart:io';

import 'package:iepub/src/log/log.dart';
import 'package:iepub/src/model/epub/metadata.dart';
import 'package:iepub/src/model/epub/manifest.dart';
import 'package:iepub/src/model/epub/spine.dart';
import 'package:iepub/src/model/epubchapte.dart';
import 'package:iepub/src/model/epubchapter_mapping.dart';
import 'package:xml/xml.dart';

class IXml {
  late final String path;

  Map params = {};

  IXml(this.path);

  Future<Map> parse() async {
    params.clear();
    String opfPath = await _getOpfPath();
    await _parseOpf('$path/$opfPath');
    return params;
  }

  /// 获取opf文件内容
  Future<String> _getOpfPath() async {
    File file = File('$path/META-INF/container.xml');
    String xml = await file.readAsString();
    final xmlDocument = XmlDocument.parse(xml);
    final rootfile = xmlDocument.findAllElements('rootfile').first;
    return rootfile.getAttribute('full-path')!;
  }

  /// 解析opf
  Future<void> _parseOpf(String path) async {
    File file = File(path);
    String xml = await file.readAsString();
    final xmlDocument = XmlDocument.parse(xml);
    final metadatas = xmlDocument.findAllElements('metadata');
    if (metadatas.isNotEmpty) {
      Metadata metadata = _parseMetadata(metadatas.first);
      Iogger.d(metadata.toJson());
    }
    final manifests = xmlDocument.findAllElements('manifest');
    if (manifests.isNotEmpty) {
      List<Manifest> list = _parseManifest(manifests.first);
      await _parseNcx('${this.path}/${list.where(
            (element) => element.id == 'ncx',
          ).toList().first.href}');
    }
    final spines = xmlDocument.findAllElements('spine');
    if (spines.isNotEmpty) {
      _parseSnine(spines.first);
    }
  }

  /// 解析书籍基础信息
  Metadata _parseMetadata(XmlElement metadata) {
    Metadata model = Metadata();
    for (var element in metadata.descendants) {
      if (element is XmlElement) {
        switch (element.qualifiedName) {
          case 'dc:creator':
            model.creator = element.text;
            break;
          case 'dc:language':
            model.language = element.text;
            break;
          case 'dc:publisher':
            model.publisher = element.text;
            break;
          case 'dc:rights':
            model.rights = element.text;
            break;
          case 'dc:title':
            model.title = element.text;
            break;
          default:
        }
      }
    }
    return model;
  }

  /// 解析主体信息
  List<Manifest> _parseManifest(XmlElement manifest) {
    List<Manifest> list = [];
    final items = manifest.findAllElements('item');
    for (var element in items) {
      Manifest model = Manifest();
      model.id = element.getAttribute('id');
      model.href = element.getAttribute('href');
      model.mediaType = element.getAttribute('media-type');
      list.add(model);
    }
    return list;
  }

  /// 解析书脊信息
  void _parseSnine(XmlElement spine) {
    List<Spine> list = [];
    final items = spine.findAllElements('itemref');
    for (var element in items) {
      Spine model = Spine();
      model.idref = element.getAttribute('idref');
      list.add(model);
    }
  }

  /// 解析ncx
  Future<void> _parseNcx(String path) async {
    File file = File(path.replaceAll('//', '/'));
    String xml = await file.readAsString();
    final xmlDocument = XmlDocument.parse(xml);
    final navMap = xmlDocument.findAllElements('navMap').first;
    final navPoints = navMap.findAllElements('navPoint');
    List<EpubChapter> chapters = [];
    List<EpubChapterMapping> mapping = [];
    for (var i = 0; i < navPoints.length; i++) {
      final element = navPoints.elementAt(i);
      chapters.add(
        EpubChapter()
          ..id = i
          ..title = element.findAllElements('text').first.text,
      );
      mapping.add(
        EpubChapterMapping()
          ..id = i
          ..href =
              element.findAllElements('content').first.getAttribute('src')!,
      );
    }
    params['chapters'] = chapters;
    params['mapping'] = mapping;
  }
}
