#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_amanisdk_v2.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_amanisdk_v2'
  s.version          = '1.2.8'
  s.summary          = 'Amani SDK Flutter bindings for ios and android SDK v2'
  s.description      = <<-DESC
  Amani v2 SDK Flutter bindings for ios and android
                       DESC
  s.homepage         = 'https://amani.ai'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mobile Team' => 'mobile_team@amani.ai' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.resources = 'Assets/**/*'
  s.dependency 'Flutter'
  s.dependency 'AmaniSDK', "~> 2.4.5"
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
