#
#  Be sure to run `pod spec lint HTAssetsPicker.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "HTAssetsPicker"
  s.version      = "0.0.1"
  s.summary      = "A short description of HTAssetsPicker."

  s.description  = <<-DESC
                   A longer description of HTAssetsPicker in Markdown format.
                   DESC

  s.homepage     = "https://github.com/NEYouFan/HTAssetsPicker-iOS"


  s.license      = "MIT"

  s.author             = { "netease" => "cxq901123@163.com" }

  s.platform     = :ios, "7.0"


  s.source       = { :path => 'https://github.com/NEYouFan/HTAssetsPicker-iOS.git', :tag => s.version.to_s }

  s.source_files  = "HTAssetsPicker/**/*.{h,m}"

end
