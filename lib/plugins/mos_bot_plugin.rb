require 'cinch'
require './lib/logger'
require './lib/extensions/hash'
require './lib/stream_finder'
require './lib/channel_info'
require './lib/channel_info_list'

# main mos bot logic
class MosBotPlugin
  include Cinch::Plugin

  timer Settings.mos_bot['update_channels_timer_interval'],
        method: :update_channels
  listen_to :connect, method: :on_connect
  match(/play/)

  def initialize(bot)
    super(bot)

    @channels = ChannelInfoList.new
  end

  def on_connect(_msg)
    update_channels
  end

  def execute(msg)
    chan = msg.channel
    return if @channels[chan].nil?

    @channels[chan].clear_obsolete_play_requests
    @channels[chan].add_play_request

    Logger.p Logger::DEBUG,
             "[#{chan}] play request noticed, " \
             "#{@channels[chan].play_requests} now"

    play chan if @channels[chan].ready_to_play?
  end

  private

  def fetch_channels
    # better don't play with the creators of mos
    blacklisted_channels = %w[pixelbypixelstudios]

    results = StreamFinder.find(
      Settings.mos_bot['channel_search_min_viewers'],
      Settings.mos_bot['channel_search_max_results']
    )

    results.reject { |k, _| blacklisted_channels.include? k }
           .map { |k, v| ["##{k}", v] }.to_h
  end

  def print_channels
    Logger.p Logger::INFO, "current channels list: #{@channels.size}"

    @channels.all.each do |channel_info|
      puts "- #{channel_info}"
    end
  end

  def update_channel(chan, data)
    if @channels[chan]
      @channels.update_channel_info chan, data
    else
      @channels.add chan, data[:viewers], data[:updated_at]
    end
  end

  def join_channels(chans)
    chans.each do |ch, _|
      Channel(ch).join
    end
  end

  def merge_fetched_channels(chans)
    chans.each do |ch, data|
      update_channel ch, data
    end
  end

  def leave_channels(chans)
    chans.each do |chan|
      Channel(chan).part
    end
  end

  def update_channels
    leave_channels @channels.delete_idle_channels
    return if @channels.size > 30

    found_channels = fetch_channels
    new_channels = found_channels.except(*@channels.channel_names)

    if new_channels.size > 0 # rubocop:disable Style/ZeroLengthPredicate
      merge_fetched_channels found_channels
      join_channels new_channels
    end

    print_channels
  end

  def play(chan)
    @channels[chan].update_my_last_play_request_at
    chan.send '!play'
    Logger.p Logger::INFO,
             "[#{chan}] PLAY REQUESTED! triggered on " \
             "#{@channels[chan].play_requests} play requests"
  end
end
