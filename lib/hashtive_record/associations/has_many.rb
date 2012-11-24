module HashtiveRecord
  module Associations
    class HasMany
      attr_reader :parent_klass, :collection_name, :foreign_key_name, :collection_class_name
      
      def initialize(parent_klass, collection_name, options={})
        @parent_klass = parent_klass
        @collection_name = collection_name
        @collection_class_name = options[:class_name] || collection_name
        @foreign_key_name = (options[:foreign_key] || "#{parent_klass.to_s.downcase}_id").to_sym
        add_to_reflection(options)
        define_reader
      end
      
      private
      
      def add_to_reflection(options)
        parent_klass.reflection.add_has_many(collection_name, options)
      end
      
      def define_reader
        _collection_name = collection_name
        _collection_class_name = collection_class_name
        _foreign_key_name = foreign_key_name
        parent_klass.send(:define_method, collection_name) do
          @_children ||= {}
          @_children[_collection_name] = AssociationProxies::CollectionProxy.build(self, _collection_class_name, _foreign_key_name)
        end
      end
      
    end
  end
end