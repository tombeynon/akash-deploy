module Akash
  class Service
    attr_reader :key, :data, :port_data

    def initialize(key, data, port_data)
      @key = key
      @data = data
      @port_data = port_data
    end

    def name
      key.to_s.titleize
    end

    def available
      data['available']
    end

    def total
      data['available']
    end

    def uris
      return [] unless data['uris']

      data['uris'].map do |uri|
        URI::HTTP.build(host: uri)
      end
    end

    def ports
      port_data.map(&:symbolize_keys)
    end
  end
end
