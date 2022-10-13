import 'dart:convert';

class Spine {
  /// 与manifest中itme的id对应
  String? idref;

  Map<String, dynamic> toJson() {
    return {
      'idref': idref,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
