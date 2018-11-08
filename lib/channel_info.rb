require './lib/extensions/time'

# contains all channel data
class ChannelInfo
  attr_accessor :name, :viewers, :updated_at, :last_play_request_at,
                :my_last_play_request_at, :play_requests

  def initialize(params)
    now = Time.now

    @name = params[:name]
    @viewers = params[:viewers]
    @updated_at = params[:updated_at]

    @last_play_request_at =
      now - Settings.mos_bot['last_play_request_interval']
    @my_last_play_request_at = now
    @play_requests = 0
  end

  def clear_play_requests
    @play_requests = 0
  end

  def add_play_request
    @play_requests += 1
    update_last_play_request_at
  end

  def update_last_play_request_at
    @last_play_request_at = Time.now
  end

  def update_my_last_play_request_at
    @my_last_play_request_at = Time.now
  end

  def any_play_requests?
    @play_requests > 0
  end

  def obsolete_play_requests?
    any_play_requests? &&
      @last_play_request_at +
        Settings.mos_bot['last_play_request_interval'] < Time.now
  end

  def clear_obsolete_play_requests
    clear_play_requests if obsolete_play_requests?
  end

  def ready_to_play?
    @play_requests >= Settings.mos_bot['min_play_requests_to_play'] &&
      (@my_last_play_request_at +
        Settings.mos_bot['my_play_request_interval'] < Time.now)
  end

  def idle?
    last_play_request_at +
      Settings.mos_bot['leaving_channel_timeout'] < Time.now
  end

  def formatted_name
    format('%-23.23s', @name)
  end

  def formatted_viewers
    format('%-15.15s', "viewers: #{@viewers}")
  end

  def formatted_play_requests
    format('%-19.19s', "play_requests: #{@play_requests}")
  end

  def formatted_updated_at
    "updated_at: #{@updated_at.simple_clock_format}"
  end

  def formatted_last_play_request_at
    "last_play_request: #{@last_play_request_at.simple_clock_format}"
  end

  def formatted_my_last_play_request_at
    "my_last_play_request: #{@my_last_play_request_at.simple_clock_format}"
  end

  def to_s
    "#{formatted_name}, #{formatted_viewers}, #{formatted_play_requests}, " \
      "#{formatted_updated_at}, #{formatted_last_play_request_at}, " \
      "#{formatted_my_last_play_request_at}"
  end
end
