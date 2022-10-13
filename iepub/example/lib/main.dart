/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-12 21:26:28
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-13 23:28:54
 * @FilePath: /iepub/example/lib/main.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:iepub/iepub.dart';

void main() async {
  await Iepub.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  EpubBook? epubBook;

  String? html;

  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: epubBook?.chapters.length,
            itemBuilder: (_, index) {
              final chapter = epubBook!.chapters[index];
              return InkWell(
                onTap: () async {
                  this.index = index;
                  // html = await Iepub.instance.getContentByIndex(
                  //   epubBook!.id,
                  //   index: index,
                  // );
                  setState(() {});
                },
                child: SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      Text(
                        chapter.title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colors.black.withOpacity(0.4),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Html(data: html ?? ''),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: const Text(
                      '载入epub',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      final byteData = await rootBundle.load('assets/3.epub');
                      epubBook = await Iepub.instance.parse(
                        '3',
                        data: byteData.buffer.asInt8List(),
                      );
                      setState(() {});
                    },
                  ),
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: const Text(
                      '删除epub',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Iepub.instance.removeEpubById('3');
                    },
                  ),
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: const Text(
                      '载入章节',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      Iepub.instance.loadChapter(
                        '3',
                        start: 0,
                        end: 5,
                      );
                    },
                  ),
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: const Text(
                      '下一章',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      index += 1;
                      // html = await Iepub.instance.getContentByIndex(
                      //   epubBook!.id,
                      //   index: index,
                      // );
                      setState(() {});
                    },
                  ),
                  MaterialButton(
                    color: Colors.lightBlue,
                    child: const Text(
                      '上一章',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      index -= 1;
                      // html = await Iepub.instance.getContentByIndex(
                      //   epubBook!.id,
                      //   index: index,
                      // );
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
