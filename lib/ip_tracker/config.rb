require 'yaml'
module IpTracker
  class Config
    attr_accessor :config_hash, :settings_path

    def initialize(options={})
      @settings_path = File.expand_path(IpTracker::DEFAULT_CONFIG_PATH)
      @config_hash = load_settings || {}
    end

    def host_token
      config_hash["host_token"] || nil
    end

    def pid
      config_hash["pid"] || nil
    end

    def update(attr, value)
      config_hash[attr.to_s] = value

      File.open(settings_path, 'w') do |out|
        YAML.dump(config_hash, out)
      end
    end

    private

    def load_settings
      File.exists?(settings_path) ? YAML.load_file(settings_path) : nil
    end
  end
end
