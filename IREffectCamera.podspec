Pod::Spec.new do |spec|
  spec.name         = "IREffectCamera"
  spec.version      = "1.0.0"
  spec.summary      = "Make a Button Group to control."
  spec.description  = "Make a Button Group to control."
  spec.homepage     = "https://github.com/irons163/IREffectCamera.git"
  spec.license      = "MIT"
  spec.author       = "irons163"
  spec.platform     = :ios, "9.0"
  spec.source       = { :git => "https://github.com/irons163/IREffectCamera.git", :tag => spec.version.to_s }
  spec.source_files  = "IREffectCamera/Classes/**/*.{h,m,xib}"
  spec.resources = ["IREffectCamera/**/*.xcassets", "IREffectCamera/**/*.bundle"]
  spec.dependency "IRCameraSticker"
end
