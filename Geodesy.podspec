Pod::Spec.new do |s|
  s.name          	= "Geodesy"
  s.version      	= "v1.0"
  s.summary      	= "A Swift implementation of the geohash algorithm."
  s.homepage    	= "https://github.com/proxpero/Geodesy"
  s.license      	= { :type => "MIT", :file => "LICENSE" }
  s.author       	= "Todd Olsen"
  s.social_media_url   	= "http://twitter.com/proxpero"
  s.source       	= { :git => "https://github.com/proxpero/Geodesy.git", :tag => "#{s.version}" }
  s.source_files  	= "Source"
end
