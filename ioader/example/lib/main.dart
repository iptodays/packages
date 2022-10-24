/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-10-09 14:36:05
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-24 21:55:15
 * @FilePath: /ioader/example/lib/main.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */

import 'package:flutter/material.dart';
import 'package:ioader/ioader.dart';

void main() async {
  await Ioader.instance.initialize();
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

class Video {
  final String id;

  final String videoUrl;

  final String coverUrl;

  Video({
    required this.id,
    required this.videoUrl,
    required this.coverUrl,
  });
}

class _MyHomePageState extends State<MyHomePage> {
  List<Video> list = [
    Video(
      id: '123',
      videoUrl: 'http://1.meiying.video:2100/20220509/ib16qrlp/index.m3u8',
      coverUrl:
          'https://images.hdqwalls.com/wallpapers/bthumb/gandalf-and-the-balrog-5k-zn.jpg',
    ),
    Video(
      id: '321',
      videoUrl:
          'http://video.meiying.cool:90/video/m3u8/2022/05/27/65d54b9c/m3u8.m3u8',
      coverUrl:
          'https://images.hdqwalls.com/download/small-memory-8k-2a-7680x4320.jpg',
    )
  ];

  int? index;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const HistoryPage(),
              ),
            ),
            icon: const Icon(
              Icons.history,
            ),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          this.index = index;
                        });
                      },
                      child: SizedBox(
                        height: 56,
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                list[index].videoUrl,
                              ),
                            ),
                            Icon(
                              this.index == index
                                  ? Icons.check_box_rounded
                                  : Icons.check_box_outline_blank,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: download,
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: delete,
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                ),
                ElevatedButton(
                  onPressed: play,
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 下载
  void download() async {
    if (index != null) {
      await Ioader.instance.put(
        list[index!].id,
        videoUrl: list[index!].videoUrl,
        coverUrl: list[index!].coverUrl,
      );
    }
  }

  /// 删除
  void delete() async {
    if (index != null) {
      Ioader.instance.removeVideoByIds([list[index!].id]);
    }
  }

  /// 播放
  void play() async {
    if (index != null) {
      String? url = await Ioader.instance.getVideoUrlById(list[index!].id);
      print(url);
    }
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<StatefulWidget> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final ioader = Ioader.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Iideo>>(
        future: ioader.getAllVideo(),
        builder: (_, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const CircularProgressIndicator();
          }
          return ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 24,
            ),
            itemCount: snapshot.data?.length,
            itemBuilder: (_, index) {
              Iideo iideo = snapshot.data![index];
              return Item(iideo: iideo);
            },
          );
        },
      ),
    );
  }
}

class Item extends StatefulWidget {
  const Item({
    super.key,
    required this.iideo,
  });

  final Iideo iideo;

  @override
  State<StatefulWidget> createState() => _ItemState();
}

class _ItemState extends State<Item> {
  Iideo get iideo => widget.iideo;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(iideo.videoUrl),
        StreamBuilder<Iideo?>(
          stream: Ioader.instance.watchVideoById(iideo.id),
          builder: (_, snapshot) {
            double value = 0;
            if (snapshot.connectionState == ConnectionState.active) {
              value = snapshot.data!.received! / snapshot.data!.total!;
            }
            return Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: value,
                  ),
                ),
                Text(value.toStringAsFixed(2))
              ],
            );
          },
        )
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
