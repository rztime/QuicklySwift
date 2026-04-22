#
# Be sure to run `pod lib lint QuicklySwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QuicklySwift'
  s.version          = '1.1.0'
  s.summary          = 'swift 常用方法扩展，便捷使用 qq交流群：580839749'
  
  s.description      = <<-DESC
  swift 常用方法扩展，便捷使用，所有方法以“q”开头，使用链式语法  "rztime@vip.qq.com" "https://github.com/rztime/QuicklySwift.git"
  DESC
  
  s.homepage         = 'https://github.com/rztime/QuicklySwift'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rztime' => 'rztime@vip.qq.com' }
  s.source           = { :git => 'https://github.com/rztime/QuicklySwift.git', :tag => s.version.to_s }
  s.social_media_url = 'https://github.com/rztime'
  
  s.ios.deployment_target = '12.0'
  s.swift_versions = ['4.2', '5.0']
  s.source_files = 'QuicklySwift/Classes/**/*'
  s.dependency 'SnapKit'

  s.script_phase = {
      :name => 'pod compile before',
      :script => <<-'SH',
        ROOT_PATH=$(dirname "$SRCROOT")
        auth_list=("NSCameraUsageDescription" "NSPhotoLibraryUsageDescription" "NSMicrophoneUsageDescription" "NSContactsUsageDescription" "NSLocationWhenInUseUsageDescription" "NSLocationAlwaysUsageDescription" "NSLocationAlwaysAndWhenInUseUsageDescription" "NSCalendarsUsageDescription" "NSRemindersUsageDescription" "NSAppleMusicUsageDescription" "NSSpeechRecognitionUsageDescription" "NSMotionUsageDescription" "NSSiriUsageDescription" "NSUserTrackingUsageDescription")
        # 收集所有相关的 Info.plist
        # 排除 Pods, .git, Tests 目录
        ALL_PLISTS=$(find "$ROOT_PATH" -name "Info.plist" -not -path "*/Pods/*" -not -path "*/.git/*" -not -path "*/Tests/*" -not -path "*.framework/*" -not -path "*.bundle/*")
        
        if [ -z "$ALL_PLISTS" ]; then
            echo "QuicklySwift: 未发现任何 Info.plist，跳过"
            exit 0
        fi
        echo "info.plists:$ALL_PLISTS"
        # 提取权限宏（去重合并）
        detected_macros=""
        for plist in $ALL_PLISTS; do
            filename=$(basename "$plist")
            if [[ "$filename" == *"-"* ]]; then continue; fi
            # 移除注释后提取内容
            content=$(cat "$plist" | perl -0777 -pe "s/<!--.*?-->//gs")
            for auth in "${auth_list[@]}"; do
                if grep -q "${auth}" <<< "${content}"; then
                    detected_macros+="${auth} "
                fi
            done
        done
        # 排序并去重
        unique_macros=$(echo "$detected_macros" | xargs -n1 | sort -u | xargs)
        formatted_macros=""
        if [ -n "$unique_macros" ]; then
            for m in $unique_macros; do
                formatted_macros+="Q_${m} "
            done
        fi
        # 拼接最终的条件行
        result_line="SWIFT_ACTIVE_COMPILATION_CONDITIONS = \$(inherited) ${formatted_macros}"
        # 写入 xcconfig
        find "$SRCROOT" -type f -name "QuicklySwift.*.xcconfig" | while read -r file; do
            # 检查是否已有完全匹配的行，避免重复写入
            if ! grep -qF "$result_line" "$file"; then
                sed -i '' '/SWIFT_ACTIVE_COMPILATION_CONDITIONS/d' "$file"
                echo "$result_line" >> "$file"
                echo "QuicklySwift: 已更新宏定义至 $file"
            fi
        done
      SH
      :shell_path => '/bin/sh',
      :execution_position => :before_compile
    }
end
