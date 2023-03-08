# Uncomment the next line to define a global platform for your project
source 'https://github.com/CocoaPods/Specs.git'

inhibit_all_warnings!
use_frameworks!

def import_pods
    pod 'AKNetworking',  :git => 'git@github.com:maverick-poc/maverick-ibm-AKNetworking.git'
end

 platform :ios, '13.0'

target 'BNIMobile' do
    import_pods
end

target 'BNIMobileTests' do
    import_pods
end

target 'BNIMobileUITests' do
    import_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['ENABLE_BITCODE'] = 'NO'
	config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
	config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ' '
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
        config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
        config.build_settings['SWIFT_VERSION'] = '5.0'
        config.build_settings['CODE_SIGN_STYLE'] = “Automatic”      
      end
    end
end

