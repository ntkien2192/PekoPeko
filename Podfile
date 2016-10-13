# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'PekoPeko' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'Alamofire', :git => 'https://github.com/Homely/Alamofire.git', :branch => 'ios8'
  pod 'SwiftyJSON'
  pod 'Spring', :git => 'https://github.com/MengTo/Spring.git', :branch => 'swift3'
  pod 'ObjectMapper', '~> 2.0'
  pod 'SwiftHEXColors', :git => 'https://github.com/thii/SwiftHEXColors.git', :branch => 'swift-3.0'
  pod 'MBProgressHUD', '~> 1.0.0'
  pod 'UIResponder+KeyboardCache', '~> 0.1'
  pod 'NVActivityIndicatorView'
  pod 'NYSegmentedControl'
  pod "MTBBarcodeScanner"
  pod 'HanekeSwift', :git => 'https://github.com/Haneke/HanekeSwift.git', :branch => 'feature/swift-3'
  pod 'PullToRefresher', '~> 2.0'
  
  # Pods for PekoPeko

  target 'PekoPekoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PekoPekoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
