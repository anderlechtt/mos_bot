require 'cinch'
require './lib/logger'

# logs basic irc actions
class EventLoggerPlugin
  include Cinch::Plugin

  listen_to :connect, method: :on_connect
  listen_to :join, method: :on_join
  listen_to :part, method: :on_part

  def on_connect(_msg)
    Logger.p Logger::INFO, 'connected to server'
  end

  def on_join(msg)
    Logger.p Logger::INFO, "joined #{msg.channel.name}"
  end

  def on_part(msg)
    Logger.p Logger::INFO, "left #{msg.channel.name}"
  end
end
