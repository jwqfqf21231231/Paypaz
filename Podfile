# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Paypaz' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for Paypaz
  
  
  target 'PaypazTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'PaypazUITests' do
    # Pods for testing
  end
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'SDWebImage'
  pod 'Alamofire','4.8.2'
  pod 'SVProgressHUD'
  pod 'IQKeyboardManagerSwift'
  pod 'LGSideMenuController'
  pod 'DropDown'
  pod 'GooglePlaces'
  pod 'GoogleMaps'
  pod 'CreditCardValidator'
  pod 'CCValidator'
  pod 'libPhoneNumber-iOS'
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
      end
       end
     end
end
