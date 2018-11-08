require 'httparty'

# uses twich api to get mos live streams
class StreamFinder
  def self.fetch_streams
    url = 'https://api.twitch.tv/kraken/streams/'
    options = {
      headers: {
        'Client-ID' => Settings.twitch_api['client_id']
      },
      format: :plain,
      query: { game: 'Marbles On Stream' }
    }

    data = HTTParty.get(url, options)
    JSON.parse data, symbolize_names: true
  end

  def self.parse_stream(stream)
    {
      stream[:channel][:name] => {
        viewers: stream[:viewers],
        updated_at: Time.now
      }
    }
  end

  def self.parse_streams(streams, min_viewers, max_channels)
    channels = {}

    if streams[:_total] > 0
      streams[:streams].each do |stream|
        break if channels.size >= max_channels
        next if stream[:viewers] < min_viewers

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
