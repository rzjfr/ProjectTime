#rackup faye_server.ru -s thin -E production -o 0.0.0.0 &
#thin -p 9292 -t 60 -R faye.ru start
require 'yaml'
require 'faye'
require 'faye/redis'
require File.expand_path('../config/initializers/faye.rb', __FILE__)

bayeux = Faye::RackAdapter.new(:mount => '/faye', :timeout => 25,
                               :engine  => { :type  => Faye::Redis,
                                             :host  => 'localhost',
                                             :port  => 6379 })

Faye::WebSocket.load_adapter('thin')

class ServerAuth
  def incoming(message, callback)
    # don't publish withoutknowing global token
    if message['channel'] !~ %r{^/meta/}
      if message['ext']['auth_token'] != FAYE_CONFIG[:token]
        message['error'] = 'Invalid authentication token'
      end
    end

    # don't let people to subscribe to any channel
    valid_channels = /\/messages\/private\/[\d\w]{64}|^\/messages\/global$/
    if (message['channel'] == '/meta/subscribe')
      if message['subscription'] !~ valid_channels
        puts message
        message['error'] = 'Unauthenticated channel to subscribe'
      end
    end

    callback.call(message)
  end

  def outgoing(message, callback)
    if message['ext'] && message['ext']['auth_token']
      message['ext'] = {}
    end
    callback.call(message)
  end
end


bayeux.add_extension(ServerAuth.new)

run bayeux
