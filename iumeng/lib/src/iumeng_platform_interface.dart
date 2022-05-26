import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'iumeng_method_channel.dart';

abstract class IumengPlatform extends PlatformInterface {
  /// Constructs a IumengPlatform.
  IumengPlatform() : super(token: _token);

  static final Object _token = Object();

  static IumengPlatform _instance = MethodChannelIumeng();

  /// The default instance of [IumengPlatform] to use.
  ///
  /// Defaults to [MethodChannelIumeng].
  static IumengPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [IumengPlatform] when
  /// they register themselves.
  static set instance(IumengPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// 获取到deviceToken的回调
  late void Function(String)? deviceTokenCallback;

  /// 注册推送回调
  late void Function(bool, int?, String?)? registerRemoteNotificationsCallback;

  /// 初始化sdk
  ///
  /// * [appKey]
  /// * [channel]
  /// * [logEnabled] 设置是否在console输出SDK的log信息.
  Future<void> initialize({
    required String appKey,
    required String channel,
    required bool logEnabled,
  }) {
    throw UnimplementedError('initialize() has not been implemented.');
  }

  /// 请求推送权限
  ///
  /// * [alert] 弹窗
  /// * [badge] 角标
  /// * [sound] 声音
  Future<void> requestPermission({
    required bool alert,
    required bool badge,
    required bool sound,
  }) {
    throw UnimplementedError('requestPermission() has not been implemented.');
  }

  /// 是否允许sdk自动清空角标
  Future<void> badgeClear() {
    throw UnimplementedError('badgeClear() has not been implemented.');
  }

  /// 在统计用户时以设备为标准，如果需要统计应用自身的账号，可以使用此功能
  ///
  /// * [puid] 用户账号ID.长度小于64字节
  /// * [provider] 账号来源。不能以下划线"_"开头，使用大写字母和数字标识，长度小于32字节
  Future<void> setProfile({
    required String puid,
    String? provider,
  }) {
    throw UnimplementedError('setProfile() has not been implemented.');
  }

  /// Signoff调用后，不再发送账号内容。
  Future<void> profileSignOff() {
    throw UnimplementedError('profileSignOff() has not been implemented.');
  }

  /// 统计页面时长
  ///
  /// * [pageName] 页面名称
  /// * [seconds] 时长/秒
  Future<void> logPageView({
    required String pageName,
    required int seconds,
  }) {
    throw UnimplementedError('logPageView() has not been implemented.');
  }

  /// 进入页面
  ///
  /// * [pageName] 页面名称
  ///
  /// 必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据；
  /// 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView。
  Future<void> beginLogPageView({
    required String pageName,
  }) {
    throw UnimplementedError('beginLogPageView() has not been implemented.');
  }

  /// 离开页面
  ///
  /// * [pageName] 页面名称
  ///
  /// 必须配对调用beginLogPageView:和endLogPageView:两个函数来完成自动统计，若只调用某一个函数不会生成有效数据；
  /// 在该页面展示时调用beginLogPageView:，当退出该页面时调用endLogPageView。
  Future<void> endLogPageView({
    required String pageName,
  }) {
    throw UnimplementedError('endLogPageView() has not been implemented.');
  }

  /// 自定义事件
  ///
  /// * [eventId] 网站上注册的事件Id
  /// * [label] 分类标签, 不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签。
  /// * [attributes] 自定义属性, 属性中的key－value必须为String类型, 每个应用至多添加500个自定义事件，key不能超过100个。
  /// * [counter] 自定义数值
  /// * [millisecond] 时长, 传入自己统计的时长（单位：毫秒）。
  ///
  /// event id长度不能超过128个字节，key不能超过128个字节，value不能超过256个字节
  ///
  /// id、ts、du、token、device_name、device_model 、device_brand、country、city、channel、
  /// province、appkey、app_version、access、launch、pre_app_version、terminate、no_first_pay、
  /// is_newpayer、first_pay_at、first_pay_level、first_pay_source、first_pay_user_level、
  /// first_pay_versio是保留字段，不能作为event id 及key的名称
  Future<void> logEvent({
    required String eventId,
    String? label,
    Map<String, String>? attributes,
    int? counter,
    int? millisecond,
  }) {
    throw UnimplementedError('logEvent() has not been implemented.');
  }

  /// 计算事件, 事件开始
  ///
  /// * [eventId] 网站上注册的事件Id
  /// * [label] 分类标签, 不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签。
  /// * [primarykey] 唯一标识, 这个参数用于和event_id一起标示一个唯一事件，并不会被统计；对于同一个事件在beginEvent和endEvent 中要传递相同的eventId 和 primarykey。
  /// * [attributes] 自定义属性, 属性中的key－value必须为String类型, 每个应用至多添加500个自定义事件，key不能超过100个。
  /// * [millisecond] 时长, 传入自己统计的时长（单位：毫秒）。
  ///
  /// beginEvent需要和endEvent配对使用，需要传入相同的eventId。
  Future<void> beginEvent({
    required String eventId,
    String? label,
    String? primarykey,
    Map<String, String>? attributes,
  }) {
    throw UnimplementedError('beginEvent() has not been implemented.');
  }

  /// 计算事件, 事件结束
  ///
  /// * [eventId] 网站上注册的事件Id
  /// * [label] 分类标签, 不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签。
  /// * [primarykey] 唯一标识, 这个参数用于和event_id一起标示一个唯一事件，并不会被统计；对于同一个事件在beginEvent和endEvent 中要传递相同的eventId 和 primarykey。
  /// * [attributes] 自定义属性, 属性中的key－value必须为String类型, 每个应用至多添加500个自定义事件，key不能超过100个。
  /// * [millisecond] 时长, 传入自己统计的时长（单位：毫秒）。
  ///
  /// beginEvent需要和endEvent配对使用，需要传入相同的eventId。
  Future<void> endEvent({
    required String eventId,
    String? label,
    String? primarykey,
  }) {
    throw UnimplementedError('endEvent() has not been implemented.');
  }
}
