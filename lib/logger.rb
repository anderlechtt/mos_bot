# logger singleton
module Logger
  module_function

  DEBUG = 3
  INFO = 2

  @log_level = Settings.mos_bot['log_level']

  def p(lvl, msg)
    return if lvl > @log_level

    puts "[#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}] #{msg}"
  end
end
