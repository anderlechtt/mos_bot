require 'cinch'
require './lib/log'

# logs basic irc actions
class EventLoggerPlugin
  include Cinch::Plugin
  include Log

  listen_to :connect, method: :on_connect
  listen_to :join, method: :on_join
  listen_to :part, method: :on_part

  def on_connect(_msg)
    logger.info 'connected to server'
  end

  def on_join(msg)
    logger.info "joined #{msg.channel.name}"
  end

  def on_part(msg)
    logger.info "left #{msg.channel.name}"
  end
end
