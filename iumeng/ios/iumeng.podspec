#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint iumeng.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'iumeng'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter project.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true
  s.dependency 'UMCommon', '~> 7.3.7'
  s.dependency 'UMPush', '~> 4.0.2'
  s.dependency 'UMDevice', '~> 2.2.1'
  s.dependency 'UMAPM', '~> 1.6.3'
  s.dependency 'UMCCommonLog', '~> 2.0.2'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
