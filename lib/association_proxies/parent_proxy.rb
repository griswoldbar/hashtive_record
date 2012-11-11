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
        @association_klass = parent_klass_name.to_class
      end
      
      def valid_klass?(object)
        (object.is_a? association_klass)
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
    
    class PolymorphicParentProxy < ParentProxy
      def self.build(association_module_name, parent_klass_name, parent_id)
        proxy = new(association_module_name)
        association_polymorph = parent_klass_name.to_class
        proxy.association = association_polymorph.find(parent_id)
        proxy
      end
      
    end
    
  end

end