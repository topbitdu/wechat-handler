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
  spec.summary     = 'Wechat Handler Engine 微信回调处理引擎'
  spec.description = 'Wechat Handler engine handles the Wechat event & message notifications. 微信回调处理引擎处理微信服务器发出的事件通知和消息通知。'
  spec.license     = 'MIT'

  spec.files         = Dir[ '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md' ]
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = [ 'lib' ]

  spec.add_dependency 'rails', '~> 4.2'
  spec.add_dependency 'wechat-validation', '~> 0.2'
  spec.add_dependency 'wechat-validator',  '~> 0.3'
  spec.add_dependency 'wechat-callback',   '~> 0.3'

end
