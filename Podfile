# Uncomment the next line to define a global platform for your project
platform :ios, '17.0'

  inhibit_all_warnings!

target 'AKTV' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  inhibit_all_warnings!

  # Pods for AKTV
  pod 'SnapKit'
  pod 'ScreenCorners'
  pod 'ComplimentaryGradientView'
  pod 'YouTubePlayer'
  pod 'IGDB-SWIFT-API', git: "https://github.com/husnjak/IGDB-API-SWIFT.git"
#  pod 'Kingfisher', '~> 6.0'
  pod 'JTAppleCalendar'

  # Targets
  target 'AKTVTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AKTVUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
