Pod::Spec.new do |s|
  s.name          		= "Geodesy"
  s.version      		= "1.0"
  s.summary      		= "A Swift implementation of the geohash algorithm."
  s.homepage    		= "https://github.com/proxpero/Geodesy"
  s.license			= { :type => "MIT", :file => "LICENSE"}
  s.author       		= "Todd Olsen"
  s.social_media_url   		= "http://twitter.com/proxpero"
  s.ios.deployment_target	= "9.0"
  s.osx.deployment_target 	= "10.10"
  s.watchos.deployment_target 	= "2.0"
  s.tvos.deployment_target 	= "9.0"
  s.source       		= { :git => "https://github.com/proxpero/Geodesy.git", :tag => "1.0" }
  s.source_files  		= "Source/*.swift"
end
