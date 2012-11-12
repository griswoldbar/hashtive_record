module HashtiveRecord
  module AssociationProxies
    class CollectionProxy
      attr_accessor :collection_klass, :collection, :parent_association_name
      
      def self.build(collection_name, foreign_key_name, foreign_key, parent_klass_name)
        proxy = new(collection_name)
        proxy.parent_association_name = foreign_key_name.to_s.chomp("_id").to_sym
        
        proxy.collection = if proxy.polymorphic?
          association_klass_name = (proxy.parent_association_name.to_s+"_class_name").to_sym
          
          proxy.collection_klass.find_by({foreign_key_name => foreign_key, association_klass_name => parent_klass_name })
        else
          proxy.collection_klass.find_by({foreign_key_name => foreign_key})
        end
        
        proxy
      end
      
      def polymorphic?
        collection_klass.reflection.belongs_tos[parent_association_name][:polymorphic]
      end
      
      def initialize(collection_name)
        @collection_klass = collection_name.to_class
      end
      
      def method_missing(method, *args, &block)
        if collection.respond_to?(method)
          collection.send(method, *args, &block)
        else
          super(method, *args, &block)
        end
      end
    
      def respond_to?(method, include_private = false)
        super || collection.respond_to?(method, include_private)
      end
    
      def inspect
        collection.inspect
      end
      
      def valid_klass?(object)
        (object.is_a? collection_klass)
      end
      
      def << (object)
        throw "this method doesn't update the foreign key in the object itself"
        if valid_klass?(object)
          collection << object
        else
          raise HashtiveRecord::Associations::TypeMismatch, object
        end
      end
    
    end
    
    
    
  end

end