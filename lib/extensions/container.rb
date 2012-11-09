module HashtiveRecord
  module Container
    extend ActiveSupport::Concern
    
    def find(id)
      collection.find { |rec| rec.id == id }
    end
  
    def method_missing(method, *args, &block)
      if collection.respond_to?(method)
        collection.send(method, *args, &block)
      elsif find(method)
        find(method)
      else
        super(method, *args, &block)
      end
    end

    def respond_to?(method, include_private = false)
      super || collection.respond_to?(method, include_private)
    end
    
    def collection
      send(self.class.collection)
    end
    
    def collection=(val)
      send("#{self.class.collection}=".to_sym, val)
    end
    
    module ClassMethods
      def collection(name=nil)
        @collection ||= name
      end
    end
    
  end
end