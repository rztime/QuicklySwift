#
# Be sure to run `pod lib lint QuicklySwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QuicklySwift'
  s.version          = '0.8.0'
  s.summary          = 'swift 常用方法扩展，便捷使用 qq交流群：580839749'
  
  s.description      = <<-DESC
  swift 常用方法扩展，便捷使用，所有方法以“q”开头，使用链式语法  "rztime@vip.qq.com" "https://github.com/rztime/QuicklySwift.git"
  DESC
  
  s.homepage         = 'https://github.com/rztime/QuicklySwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rztime' => 'rztime@vip.qq.com' }
  s.source           = { :git => 'https://github.com/rztime/QuicklySwift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/rztime'
  
  s.ios.deployment_target = '10.0'
  s.swift_versions = ['4.2', '5.0']
  s.source_files = 'QuicklySwift/Classes/**/*'
  s.dependency 'SnapKit'

  sc1 = '''
    root_path="${SRCROOT}"
    info_plist_path=$(dirname "$root_path")
    find "$info_plist_path" -iname "info.plist" | while read -r line; do
      auth_list=("NSCameraUsageDescription" "NSPhotoLibraryUsageDescription" "NSMicrophoneUsageDescription" "NSContactsUsageDescription" "NSLocationWhenInUseUsageDescription" "NSLocationAlwaysUsageDescription" "NSLocationAlwaysAndWhenInUseUsageDescription" "NSCalendarsUsageDescription" "NSRemindersUsageDescription" "NSAppleMusicUsageDescription" "NSSpeechRecognitionUsageDescription" "NSMotionUsageDescription" "NSSiriUsageDescription" "NSUserTrackingUsageDescription")
      use_list=("\$(inherited)")
      infoplist_content=$(cat "$line")
      for auth in "${auth_list[@]}"; do
        if grep -q "${auth}" <<< "${infoplist_content}"; then
          use_list+=("Q_${auth}")
        fi
      done
    
      if [ "${#use_list[@]}" -eq 1 ]; then
        echo "忽略"
      else
        result_list="\nSWIFT_ACTIVE_COMPILATION_CONDITIONS = ${use_list[@]}"
        find "$root_path" -type f -name "QuicklySwift.debug.xcconfig" | while read -r file; do
            content=$(cat "${file}")
            if grep -q "SWIFT_ACTIVE_COMPILATION_CONDITIONS" <<< "$content"; then
                content=$(echo "$content" | grep -v "SWIFT_ACTIVE_COMPILATION_CONDITIONS")
            fi
            content+="${result_list}"
            echo "$content" > "$file"
        done
        find "$root_path" -type f -name "QuicklySwift.release.xcconfig" | while read -r file; do
            content=$(cat "${file}")
            if grep -q "SWIFT_ACTIVE_COMPILATION_CONDITIONS" <<< "$content"; then
                content=$(echo "$content" | grep -v "SWIFT_ACTIVE_COMPILATION_CONDITIONS")
            fi
            content+="${result_list}"
            echo "$content" > "$file"
        done
      fi
    done
  '''
  s.script_phase = {
    :name => 'pod compile before',
    :script => sc1,
    :shell_path => '/bin/sh',
    :execution_position => :before_compile
  }
end
