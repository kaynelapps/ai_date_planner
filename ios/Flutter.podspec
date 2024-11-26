Pod::Spec.new do |s|
  s.name             = 'Flutter'
  s.version          = '1.0.0'
  s.summary          = 'Flutter Engine Framework'
  s.description      = 'Flutter provides an easy and productive way to build and deploy cross-platform mobile applications.'
  s.homepage         = 'https://flutter.io'
  s.license          = { :type => 'MIT' }
  s.author           = { 'Flutter Dev Team' => 'flutter-dev@googlegroups.com' }
  s.source           = { :git => 'https://github.com/flutter/engine', :tag => s.version.to_s }
  s.ios.deployment_target = '11.0'
  s.vendored_frameworks = 'Flutter.framework'
  s.dependency 'Flutter'
end

