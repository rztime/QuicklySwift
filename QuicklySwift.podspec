#
# Be sure to run `pod lib lint QuicklySwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QuicklySwift'
  s.version          = '0.1.1'
  s.summary          = 'swift 常用方法扩展，便捷使用'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  swift 常用方法扩展，便捷使用，所有方法以“q”开头，使用链式语法
                       DESC

  s.homepage         = 'https://github.com/rztime/QuicklySwift'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rztime' => 'rztime@vip.qq.com' }
  s.source           = { :git => 'https://github.com/rztime/QuicklySwift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/rztime'

  s.ios.deployment_target = '9.0'
  s.swift_versions = ['4.2', '5.0']

  s.source_files = 'QuicklySwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'QuicklySwift' => ['QuicklySwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
  s.dependency 'SnapKit'
  
end
