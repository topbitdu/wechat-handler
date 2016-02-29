# Wechat Handler 微信回调处理引擎

[![License](https://img.shields.io/badge/license-MIT-green.svg)](http://opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/wechat-handler.svg)](https://badge.fury.io/rb/wechat-handler)

The Wechat Handler engine handles the Wechat event & message notifications. 微信回调处理引擎处理微信服务器发出的事件通知和消息通知。

## Usage in Gemfile
```ruby
gem 'wechat-handler'
```

## Include the controller concern
```ruby
include ::Wechat::Handler::Concerns::Dispatcher

def on_event(pairs)
  { 'MsgType' => 'text', 'Content' => 'Aloha!' }
end
```

The Dispatcher handles the ToUserName, the FromUserName, and the CreateTime automatically.
