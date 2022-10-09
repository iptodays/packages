/*
 * @Author: iptoday wangdong1221@outlook.com
 * @Date: 2022-09-28 22:46:22
 * @LastEditors: iptoday wangdong1221@outlook.com
 * @LastEditTime: 2022-10-09 14:41:07
 * @FilePath: /ioader/test/ioader_test.dart
 * 
 * Copyright (c) 2022 by iptoday wangdong1221@outlook.com, All Rights Reserved.
 */
import 'package:flutter_test/flutter_test.dart';
import 'package:ioader/ioader.dart';

void main() {
  test('adds one to input values', () async {
    await Ioader.initialize('123231');
  });
}
