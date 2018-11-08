require './lib/logger'

# manages a list of channel data
class ChannelInfoList
  def initialize
    @channels = {}
  end

  def [](chan)
    @channels[chan]
  end

  def []=(chan, value)
    @channels[chan] = value
  end

  def update_channel_info(chan, data)
    @channels[chan].viewers = data[:viewers]
    @channels[chan].updated_at = data[:updated_at]
  end

  def idle_channels
    @channels.select { |_ch, ci| ci.idle? }.map { |ch, _ci| ch }
  end

  def delete_idle_channels
    chans = idle_channels
    chans.each do |ch|
      @channels.delete ch
    end

    unless chans.empty?
      Logger.p Logger::DEBUG, "channels after delete: #{@channels}"
    end

    chans
  end

  def size
    @channels.size
  end

  def channel_names
    @channels.keys
  end

  def all
    @channels.map { |_ch, ci| ci }
  end

  def add(chan, viewers, updated_at)
    @channels[chan] = ChannelInfo.new(
      name: chan,
      viewers: viewers,
      updated_at: updated_at
    )
  end
end
