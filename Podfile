platform :ios, '13.0'
use_frameworks!
inhibit_all_warnings!

target 'TechnicalTestOlimpia' do

  pod 'TransitionButton'
  pod 'CropViewController'
  pod 'NVActivityIndicatorView'
  pod 'MarqueeLabel'
  pod 'lottie-ios'
  pod 'PureLayout'
  pod 'LanguagesManager'
  pod 'GoogleSignIn'
  pod 'Firebase'
  pod 'Alamofire', '~> 5.1'
  pod 'CropViewController'
  pod 'GoogleWebRTC'

  target 'TechnicalTestOlimpiaTests' do
    inherit! :search_paths
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    puts target.name
  end
end
