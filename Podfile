pod "Mantle"
pod "MagicalRecord"
pod "SDWebImage"
pod "Dropbox-iOS-SDK"
pod "Asterism", "1.0.0-RC3"
pod "VTAcknowledgementsViewController"

target :OpenDataTests do
    pod "Expecta"
    pod "Specta"
    pod "OCMockito"
    pod "PivotalCoreKit/UIKit/SpecHelper"
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Pods-Acknowledgements.plist', :remove_destination => true)
end