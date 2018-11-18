require 'logger'

# log formatter
class LogFormatter
  def call(_severity, time, _progname, msg)
    "[#{time.strftime('%Y-%m-%d %H:%M:%S')}] #{msg}\n"
  end
end

# logger
module Log
  def logger
    Log.logger
  end

  def self.logger
    @logger ||= Logger.new(
      STDOUT,
      level: Settings.mos_bot['log_level'],
      formatter: LogFormatter.new
    )
  end
end
