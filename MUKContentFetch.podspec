Pod::Spec.new do |s|
  s.name             = "MUKContentFetch"
  s.version          = "1.3.3"
  s.summary          = "Retrieve data and transform it to content objects"
  s.description      = "A simple infrastracture to retrieve requested data and transform it to content object"
  s.homepage         = "https://github.com/muccy/MUKContentFetch"
  s.license          = 'MIT'
  s.author           = { "Marco Muccinelli" => "muccymac@gmail.com" }
  s.source           = { :git => "https://github.com/muccy/MUKContentFetch.git", :tag => s.version.to_s }

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Classes/**/*.{h,m}'
end
