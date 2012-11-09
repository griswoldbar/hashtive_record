module HashtiveRecord
  module Associations
    
    class BelongsTo
      attr_reader :belonger_klass, :parent_klass_name
      
      def initialize(belonger_klass, parent_klass_name)
        @belonger_klass = belonger_klass
        @parent_klass_name = parent_klass_name
        define_reader
        define_writer
      end
      
      private
      def define_reader
        _parent_id_name = "#{parent_klass_name}_id".to_sym
        _parent_klass_name = parent_klass_name
        
        belonger_klass.send(:define_method, parent_klass_name) do
          parent_id = send(_parent_id_name)
          @_parents ||= {}
          @_parents[_parent_klass_name] ||= HashtiveRecord::AssociationProxies::ParentProxy.build(_parent_klass_name, parent_id)
        end
      end
      
      def define_writer
        _parent_id_name = "#{parent_klass_name}_id".to_sym
        _parent_klass_name = parent_klass_name
        
        belonger_klass.send(:define_method, "#{parent_klass_name}=") do |object|
          @_parents ||= {}
          @_parents[_parent_klass_name] ||= HashtiveRecord::AssociationProxies::ParentProxy.new(_parent_klass_name)       
          raise HashtiveRecord::Associations::TypeMismatch, "#{object}" unless @_parents[_parent_klass_name].valid_klass?(object)
          @_parents[_parent_klass_name].association = object
          send("#{_parent_id_name}=", object.id)
        end
      end
      
    end
  end
  
end