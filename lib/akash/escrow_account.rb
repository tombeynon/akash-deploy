module Akash
  class EscrowAccount
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def balance
      data['balance']
    end

    def transferred
      data['transferred']
    end
  end
end
