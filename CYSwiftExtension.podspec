#
#  Be sure to run `pod spec lint CYSwiftExtension.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#
# 参考文件
# https://www.jianshu.com/p/9a5ec24ff437
# https://blog.csdn.net/qq_34534179/article/details/84639127
# https://blog.csdn.net/weixin_34318272/article/details/88039959
# https://www.jianshu.com/p/743bfd8f1d72

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name         = "CYSwiftExtension"
  spec.version      = "1.4.2"
  spec.summary      = "A short description of CYSwiftExtension."

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  spec.description  = <<-DESC
  XXXXX
                   DESC

  spec.homepage     = "http://RainyofSun/CYSwiftExtension"
  # spec.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author             = { "RainyofSun" => "liurant30@163.com" }
  # Or just: spec.author    = "RainyofSun"
  # spec.authors            = { "RainyofSun" => "liurant30@163.com" }
  # spec.social_media_url   = "https://twitter.com/RainyofSun"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  # spec.platform     = :ios
  spec.platform     = :ios, "14.0"

  #  When using multiple platforms
  # spec.ios.deployment_target = "5.0"
  # spec.osx.deployment_target = "10.7"
  # spec.watchos.deployment_target = "2.0"
  # spec.tvos.deployment_target = "9.0"
  # spec.visionos.deployment_target = "1.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source       = { :git => "https://github.com/RainyofSun/CYSwiftExtension", :tag => "#{spec.version}" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # OC 文件选择模式
  # spec.ios.source_files  = "CYSwiftExtension/Classes/*.{h,m}"
  spec.subspec 'String' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/String/*.{h,m}'
  end

  spec.subspec 'UIDevice' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/UIDevice/*.{h,m}'
      spec.dependency "YYKit", "1.0.9"
      spec.dependency "Reachability", "3.2"
      spec.dependency 'CYSwiftExtension/String'
  end

  spec.subspec 'Auth' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/Auth/*.{h,m}'
      spec.dependency 'CYSwiftExtension/ViewController'
      spec.dependency 'CYSwiftExtension/UIDevice'
  end

  spec.subspec 'NetWork' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/NetWork/*.{h,m}'
      spec.dependency "AFNetworking"
      spec.dependency "YYKit", "1.0.9"
      spec.dependency "Toast", "4.1.1"
      spec.dependency 'CYSwiftExtension/String'
      spec.dependency 'CYSwiftExtension/UIDevice'
      spec.dependency 'CYSwiftExtension/Auth'
  end

  spec.subspec 'ContactManager' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/ContactManager/*.{h,m}'
  end

  spec.subspec 'ViewController' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/ViewController/*.{h,m}'
      spec.dependency 'CYSwiftExtension/String'
  end

  # Swift 文件没有头文件
  spec.public_header_files = "CYSwiftExtension/Classes/Header/*.h"

  # Swift 文件选择模式
  # spec.ios.source_files  = "CYSwiftExtension/Classes/*"
  spec.subspec 'ScrollView' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/ScrollView/*.swift'
      spec.dependency "MJRefresh", "3.7.5"
      spec.dependency "SnapKit", "5.6.0"
  end

  spec.subspec 'GradientView' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/GradientView/*.swift'
  end

  spec.subspec 'TextView' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/TextView/*.swift'
  end

  spec.subspec 'UITextFiled' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/UITextFiled/*.swift'
  end

  spec.subspec 'MarqueeView' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/MarqueeView/*.swift'
  end

  spec.subspec 'Cache' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/Cache/*.swift'
      spec.dependency 'CYSwiftExtension/Language'
  end

  spec.subspec 'UIButton' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/UIButton/*.swift'
      spec.dependency "SnapKit", "5.6.0"
      spec.dependency 'CYSwiftExtension/GradientView'
  end

  spec.subspec 'NetOberver' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/NetOberver/*'
      spec.dependency "Reachability", "3.2"
  end

  spec.subspec 'ProtocolView' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/ProtocolView/*'
      spec.dependency "SnapKit", "5.6.0"
  end

  spec.subspec 'Language' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/Language/*'
  end

  spec.subspec 'CocoaLog' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/CocoaLog/*'
      spec.dependency "CocoaLumberjack/Swift", "3.8.5"
  end

  spec.subspec 'PhotoCamera' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/PhotoCamera/*'
      spec.dependency "YYKit", "1.0.9"
      spec.dependency "JKSwiftExtension", "2.7.1"
      spec.dependency "TZImagePickerController", "3.8.8"
  end

  spec.subspec 'Web' do |spec|
      spec.ios.source_files = 'CYSwiftExtension/Classes/Web/*'
      spec.dependency "JKSwiftExtension", "2.7.1"
      spec.dependency "SnapKit", "5.6.0"
  end

  # spec.exclude_files = "Classes/Exclude"


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # spec.resource  = "icon.png"
  # spec.resources = "Resources/*.png"

  # spec.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # spec.framework  = "SomeFramework"
  # spec.frameworks = "SomeFramework", "AnotherFramework"

  # spec.library   = "iconv"
  # spec.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # spec.requires_arc = true

  # spec.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64'}
  spec.swift_version = '5.2'
end
