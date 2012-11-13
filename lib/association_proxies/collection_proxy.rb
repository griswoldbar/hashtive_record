module HashtiveRecord
  module AssociationProxies
    class CollectionProxy
      attr_accessor :collection, :association_klass_name
      attr_reader :owner, :collection_klass, :parent_association_name, :foreign_key_name
                    # monster, Pet,             :owner,                  :owner_id
                    
      def self.build(owner, collection_name, foreign_key_name)        
        new(owner, collection_name, foreign_key_name).tap do |proxy|      
          if proxy.polymorphic?
            proxy.association_klass_name = (proxy.parent_association_name.to_s+"_class_name").to_sym
            proxy.collection = proxy.collection_klass.find_by({foreign_key_name => owner.id, proxy.association_klass_name => owner.class.name.downcase.to_sym })
          else
            proxy.collection = proxy.collection_klass.find_by({foreign_key_name => owner.id})
          end
        end
      end
            
      def initialize(owner, collection_name, foreign_key_name)
        @owner = owner
        @foreign_key_name = foreign_key_name
        @collection_klass = collection_name.to_class
        @parent_association_name = foreign_key_name.to_s.chomp("_id").to_sym
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
    
      # def inspect
      #   collection.inspect
      # end
      
      def valid_klass?(object)
        (object.is_a? collection_klass)
      end
      
      def << (object)
        if valid_klass?(object)
          object.send(foreign_key_name.eqify, owner.id)
          object.send(association_klass_name.eqify, owner.class.name.downcase.to_sym) if polymorphic?
        else
          raise HashtiveRecord::Associations::TypeMismatch, object
        end
      end
      
      def polymorphic?
        @_polymorphic ||= collection_klass.reflection.belongs_tos[parent_association_name][:polymorphic]
      end
    
    end
    

    
    
    
  end

end