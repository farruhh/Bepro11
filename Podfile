platform :ios, '13.0'
workspace 'Bepro_iOS_Task'

inhibit_all_warnings!
use_frameworks!

def ui
  pod 'SnapKit', '~> 5.0.0'
end

def networking
  pod 'Alamofire', '~> 5.1'
  pod 'PromiseKit', '~> 6.8'
  pod 'SwiftyJSON'
end

def debugging
  pod 'CocoaLumberjack/Swift'
end 

def rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxGesture'
end

target 'Bepro_iOS_Task' do
  ui
  networking
  debugging
  rx
end

target 'Bepro_iOS_TaskTests' do
    inherit! :search_paths
    # Pods for testing
end

target 'Bepro_iOS_TaskUITests' do
    # Pods for testing
end
