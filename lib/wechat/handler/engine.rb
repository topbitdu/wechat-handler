module Wechat
  module Handler

    class Engine < ::Rails::Engine

      isolate_namespace Wechat::Handler

    end

  end
end
