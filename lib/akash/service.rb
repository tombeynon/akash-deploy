module Akash
  class Service
    attr_reader :key, :data

    def initialize(key, data)
      @key = key
      @data = data
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
  end
end
