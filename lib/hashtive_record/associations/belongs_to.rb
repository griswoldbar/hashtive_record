module HashtiveRecord
  module Associations
    
    class BelongsTo
      attr_reader :belonger_klass, :parent_klass_name, :association_name
      
      def initialize(belonger_klass, parent_klass_name, options={})
        @belonger_klass = belonger_klass
        @parent_klass_name = parent_klass_name
        @association_name = options[:as] || parent_klass_name
        add_to_reflection(options)
        if options[:polymorphic]          
          define_polymorphic_reader
          define_polymorphic_writer
        else
          define_reader
          define_writer
        end
      end
      
      private
      
      def add_to_reflection(options)
        belonger_klass.reflection.add_belongs_to(parent_klass_name, options)
      end
      
      def define_polymorphic_reader
        _parent_id_name = "#{association_name}_id".to_sym
        _parent_polymorph_name = "#{association_name}_type".to_sym
        _association_name = association_name

        belonger_klass.send(:define_method, association_name) do
          parent_id = send(_parent_id_name)
          _parent_klass_name = send(_parent_polymorph_name)
          @_parents ||= {}
          @_parents[_association_name] ||= AssociationProxies::PolymorphicParentProxy.build(_association_name,_parent_klass_name, parent_id)
        end
      end
      
      def define_polymorphic_writer
        _parent_id_name = "#{association_name}_id".to_sym
        _parent_polymorph_name = "#{association_name}_type".to_sym
        _association_name = association_name
        
        belonger_klass.send(:define_method, association_name.eqify) do |object|   
          _parent_klass_name = object.class.to_s.downcase.to_sym       
          @_parents ||= {}
          @_parents[_association_name] ||= AssociationProxies::PolymorphicParentProxy.new(_association_name)       
          raise TypeMismatch, "#{object}" unless @_parents[_association_name].valid_klass?(object)
          @_parents[_association_name].association = object
          send(_parent_id_name.eqify, object.id)
          send(_parent_polymorph_name.eqify, _parent_klass_name)
        end
        
      end
      
      def define_reader
        _parent_id_name = "#{association_name}_id".to_sym
        _parent_klass_name = parent_klass_name
        _association_name = association_name
        
        belonger_klass.send(:define_method, association_name) do
          parent_id = send(_parent_id_name)
          @_parents ||= {}
          @_parents[_association_name] ||= AssociationProxies::ParentProxy.build(_parent_klass_name, parent_id)
        end
      end
      
      def define_writer        
        _parent_id_name = "#{association_name}_id".to_sym
        _parent_klass_name = parent_klass_name
        _association_name = association_name
        
        belonger_klass.send(:define_method, association_name.eqify) do |object|          
          @_parents ||= {}
          @_parents[_association_name] ||= AssociationProxies::ParentProxy.new(_parent_klass_name)
          raise TypeMismatch, "#{object}" unless @_parents[_association_name].valid_klass?(object)
          @_parents[_association_name].association = object
          send("#{_parent_id_name}=", object.id)
        end
      end
      
    end
  end
  
end