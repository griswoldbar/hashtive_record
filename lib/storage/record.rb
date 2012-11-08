module HashtiveRecord
  module Storage
    
    class Record
      attr_accessor :hash
      attr_reader :id
      
      def initialize(hash={})
        raise HashtiveRecord::RecordError, "multiple ids found on record" if hash.keys.count > 1
        @id = hash.keys.first
        @hash = hash[@id].to_ostruct
      end
      
      def method_missing(method, *args, &block)
        hash.send(method, *args, &block)
      end

      def respond_to?(method, include_private = false)
        super || hash.respond_to?(method, include_private)
      end
      
    end
  
  end
  
end