module MiniPresenters
  module Keys
    module HasOne
      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods
        def has_one(association_name, options = {})
          @has_one_associations ||= []
          @has_one_associations << [association_name, options]
        end

        def has_one_associations
          @has_one_associations || []
        end
      end

      module InstanceMethods
        def has_one_associations_hash
          Hash[self.class.has_one_associations.map do |name, options|
            next if option_and_false(options[:if])
            next if option_and_true(options[:unless])

            association_subject = resolve_key(name)
            presenter = presenter_for(association_subject, options)

            [name, presenter.to_h]
          end.compact]
        end
      end
    end
  end
end
