import 'package:flutter_test/flutter_test.dart';
import 'package:ioader/ioader.dart';

void main() {
  test('adds one to input values', () async {
    bool result = await Ioader.initialize('123231');
    print(result);
    print(Ioader().dir);
  });
}
