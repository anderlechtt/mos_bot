require 'yaml'

# settings singleton
module Settings
  module_function

  @data = {}

  def load!(filename)
    @data = YAML.load_file(filename)
  end

  def method_missing(name, *_args, &_block)
    @data[name.to_s] || super
  end

  def respond_to_missing?(method_name, include_private = false)
    !@data[method_name.to_s].nil? || super
  end
end
