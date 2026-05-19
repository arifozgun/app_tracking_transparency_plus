#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint app_tracking_transparency_plus.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'app_tracking_transparency_plus'
  s.version          = '2.1.1'
  s.summary          = 'A Flutter plugin for displaying the iOS App Tracking Transparency dialog.'
  s.description      = <<-DESC
This Flutter plugin allows you to display the iOS tracking authorization dialog and request permission to collect data.
                       DESC
  s.homepage         = 'https://github.com/arifozgun/app_tracking_transparency_plus'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Arif Ozgun' => 'https://github.com/arifozgun' }
  s.source           = { :path => '.' }
  s.source_files     = 'app_tracking_transparency_plus/Sources/app_tracking_transparency_plus/**/*.swift'
  s.resource_bundles = {
    'app_tracking_transparency_plus_privacy' => ['app_tracking_transparency_plus/Sources/app_tracking_transparency_plus/PrivacyInfo.xcprivacy']
  }
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386'
  }
  s.swift_version = '5.0'
end
