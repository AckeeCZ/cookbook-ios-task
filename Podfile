# Podfile
source 'https://github.com/CocoaPods/Specs.git' # Default Cocoapods repo

platform :ios, '9.0'
project 'Cookbook', 'AdHoc' => :release,'AppStore' => :release, 'Development' => :debug

use_frameworks!
inhibit_all_warnings!

target 'Cookbook' do

pod 'ReactiveCocoa', '~> 5'
pod 'ReactiveSwift', '~> 1'
pod 'SnapKit', '~> 3.0'
pod 'Alamofire', '~> 4.0'
pod 'Reqres'
pod 'SwiftLint'
pod 'Argo'
pod 'Curry'
end

post_install do |installer|

    puts 'Setting appropriate code signing identities'
    installer.pods_project.targets.each { |target|
        {
            'iPhone Developer' => ['Development','Debug'],
            'iPhone Distribution' => ['AppStore','AdHoc','Release'],
        }.each { |value, configs|
            target.set_build_setting('CODE_SIGN_IDENTITY[sdk=iphoneos*]', value, configs)
        }
        # set Swift 3.2 for certain projects
        if target.name == 'SnapKit' || target.name == 'ReactiveSwift' || target.name == 'ReactiveCocoa'
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = '3.2'
                puts "Changing version to 3.2 for target: #{target.name}, configuration: #{config}"
            end
        end
    }

    puts 'changing bundle versions to conform to testfligh rules'
    plist_buddy = "/usr/libexec/PlistBuddy"

    installer.pods_project.targets.each do |target|
        plist = "Pods/Target Support Files/#{target}/Info.plist"
        version = `#{plist_buddy} -c "Print CFBundleShortVersionString" "#{plist}"`.strip

        stripped_version = /([\d\.]+)/.match(version).captures[0]

        version_parts = stripped_version.split('.').map { |s| s.to_i }

        # ignore properly formatted versions
        unless version_parts.slice(0..2).join('.') == version

            major, minor, patch = version_parts

            major ||= 0
            minor ||= 0
            patch ||= 999

            fixed_version = "#{major}.#{minor}.#{patch}"

            puts "Changing version of #{target} from #{version} to #{fixed_version} to make it pass iTC verification."

            `#{plist_buddy} -c "Set CFBundleShortVersionString #{fixed_version}" "#{plist}"`
        end
    end
end



class Xcodeproj::Project::Object::PBXNativeTarget

    def set_build_setting setting, value, config = nil
        unless config.nil?
            if config.kind_of?(Xcodeproj::Project::Object::XCBuildConfiguration)
                config.build_settings[setting] = value
                elsif config.kind_of?(String)
                build_configurations
                .select { |config_obj| config_obj.name == config }
                .each { |config| set_build_setting(setting, value, config) }
                elsif config.kind_of?(Array)
                config.each { |config| set_build_setting(setting, value, config) }
                else
                raise 'Unsupported configuration type: ' + config.class.inspect
            end
            else
            set_build_setting(setting, value, build_configurations)
        end
    end

end
