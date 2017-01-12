# Wechat Handler 微信回调处理引擎

[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/gems/wechat-handler/frames)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://opensource.org/licenses/MIT)

[![Gem Version](https://badge.fury.io/rb/wechat-handler.svg)](https://badge.fury.io/rb/wechat-handler)
[![Dependency Status](https://gemnasium.com/badges/github.com/topbitdu/wechat-handler.svg)](https://gemnasium.com/github.com/topbitdu/wechat-handler)

The Wechat Handler engine handles the Wechat event & message notifications. 微信回调处理引擎处理微信服务器发出的事件通知和消息通知。



## Recent Update

Check out the [Road Map](ROADMAP.md) to find out what's the next.
Check out the [Change Log](CHANGELOG.md) to find out what's new.



## Usage in Gemfile

```ruby
gem 'wechat-handler'
```



## Include the controller concern

```ruby
include Wechat::Handler::Concerns::Dispatcher

def on_event(pairs)
  { 'MsgType' => 'text', 'Content' => 'Aloha!' }
end
```

The Dispatcher handles the ToUserName, the FromUserName, and the CreateTime automatically.
