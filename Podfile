pod "Asterism", "1.0.0-RC3"
pod "Dropbox-iOS-SDK"
pod "FontAwesomeKit/FontAwesome"
pod "MagicalRecord"
pod "Mantle"
pod "SDWebImage"
pod "VTAcknowledgementsViewController"

target :TheseusTests do
    pod "Expecta"
    pod "OCMockito"
    pod "PivotalCoreKit/UIKit/SpecHelper"
    pod "Specta"
end

post_install do | installer |
    require 'fileutils'
    FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Pods-Acknowledgements.plist', :remove_destination => true)
end
