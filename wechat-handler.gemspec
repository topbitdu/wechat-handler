$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'wechat/handler/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'wechat-handler'
  spec.version     = Wechat::Handler::VERSION
  spec.authors     = [ 'Topbit Du' ]
  spec.email       = [ 'topbit.du@gmail.com' ]
  spec.homepage    = 'https://github.com/topbitdu/wechat-handler'
  spec.summary     = 'The Wechat Handler engine includes a concern and a controller to handle the Wechat event & message notifications.'
  spec.description = 'The Wechat Handler engine handles the Wechat event & message notifications.'
  spec.license     = 'MIT'

  spec.files         = Dir[ '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md' ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = [ 'lib' ]

  spec.add_dependency 'rails', '~> 4.2'
  spec.add_dependency 'wechat-callback', '~> 0.1'

end
