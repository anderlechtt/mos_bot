require 'httparty'

# uses twich api to get mos live streams
class StreamFinder
  def self.fetch_streams
    url = 'https://api.twitch.tv/helix/streams/'
    options = {
      headers: {
        'Client-ID' => Settings.twitch_api['client_id']
      },
      format: :plain,
      query: { game_id: '509511' }
    }

    data = HTTParty.get(url, options)
    JSON.parse data, symbolize_names: true
  end

  def self.parse_stream(stream)
    {
      stream[:user_name] => {
        viewers: stream[:viewer_count],
        updated_at: Time.now
      }
    }
  end

  def self.parse_streams(streams, min_viewers, max_channels)
    channels = {}

    if streams[:data].count > 0
      streams[:data].each do |stream|
        break if channels.size >= max_channels
        next if stream[:viewer_count] < min_viewers

        channels.merge! parse_stream(stream)
      end
    end

    channels
  end

  def self.find(min_viewers = 40, max_channels = 20)
    streams = fetch_streams
    parse_streams(streams, min_viewers, max_channels)
  end
end