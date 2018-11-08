require 'cinch'
require './lib/settings'

config_filename = File.exist?('my_config.yml') ? 'my_config.yml' : 'config.yml'
Settings.load!(config_filename)

require './lib/plugins/mos_bot_plugin'
require './lib/plugins/event_logger_plugin'

def error(msg)
  puts msg
  exit(1)
end

if Settings.twitch_api['username'].nil?
  error "No username given in #{config_filename}!"
elsif Settings.twitch_api['oauth_key'].nil?
  error "No oauth key given in #{config_filename}!"
end

bot = Cinch::Bot.new do
  configure do |c|
    c.server = 'irc.twitch.tv'
    c.nick = Settings.twitch_api['username']
    c.password = Settings.twitch_api['oauth_key']
    c.channels = channels
    c.plugins.plugins = [MosBotPlugin, EventLoggerPlugin]
  end
end

bot.loggers.level = :info
bot.start
