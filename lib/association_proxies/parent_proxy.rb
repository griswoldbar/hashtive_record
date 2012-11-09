module HashtiveRecord
  module AssociationProxies
    class ParentProxy
      attr_reader :association, :association_klass
      
      def initialize(parent_klass_name, parent_id)
        @association_klass = parent_klass_name.to_s.classify.constantize
        @association = @association_klass.find(parent_id)
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