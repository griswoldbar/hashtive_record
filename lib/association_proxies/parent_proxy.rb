module HashtiveRecord
  module AssociationProxies
    class ParentProxy
      attr_accessor :association, :association_klass
      
      def self.build(parent_klass_name, parent_id)
        proxy = new(parent_klass_name)
        proxy.association = proxy.association_klass.find(parent_id)
        proxy
      end
      
      def initialize(parent_klass_name)
        @association_klass = parent_klass_name.to_s.classify.constantize
      end
      
      def valid_klass?(object)
        object.is_a? association_klass
      end
      
      def method_missing(method, *args, &block)
        if association.respond_to?(method)
          association.send(method, *args, &block)
        else
          super(method, *args, &block)
        end
      end

      def respond_to?(method, include_private = false)
        super || association.respond_to?(method, include_private)
      end
    end
  end

end