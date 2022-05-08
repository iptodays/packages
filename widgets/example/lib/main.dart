import 'package:flutter/material.dart';
import 'package:widgets/state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Demo(),
      ),
    );
  }
}

class Demo extends StatefulWidget {
  const Demo({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => DemoState();
}

class DemoState extends CustomState<Demo> {
  @override
  bool get executeLoadData => true;

  @override
  Widget customBuild(BuildContext context) {
    return CustomScaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(''),
      ),
    );
  }

  @override
  Future<void> loadData() async {}
}
