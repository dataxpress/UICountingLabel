Pod::Spec.new do |s|
  s.name         = "UICountingLabel"
  s.version      = "1.4.1"
  s.summary      = "Adds animated counting support to UILabel."
  s.homepage     = "https://github.com/dataxpress/UICountingLabel"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Tim Gostony" => "dataxpress@gmail.com" }
  s.source       = { :git => "https://github.com/dataxpress/UICountingLabel.git", :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'
  s.source_files = 'UICountingLabel/Classes/**/*'
  s.private_header_files = 'UICountingLabel/Classes/include/**/*.h'
  s.requires_arc = true
end
