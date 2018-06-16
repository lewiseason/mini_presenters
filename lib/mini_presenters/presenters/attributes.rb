module MiniPresenters
  module Presenters
    module Attributes
      def self.included(base)
        base.send :include, InstanceMethods
        base.extend ClassMethods
      end

      module ClassMethods
        def attributes(*args)
          @attribute_groups ||= []

          args, opts = extract_options!(args)
          @attribute_groups << [args, opts]
        end

        def extract_options!(args)
          return [args, {}] unless args.last.is_a?(Hash)

          opts = args.pop
          [args, opts]
        end

        def attribute_groups
          @attribute_groups
        end
      end

      module InstanceMethods
        def attributes_hash
          groups = self.class.attribute_groups.map do |attribute_names, options|
            next if option_and_false(options[:if])
            next if option_and_true(options[:unless])

            attribute_names
          end

          Hash[groups.flatten.compact.map { |al| resolve_attribute(al) }]
        end

        def resolve_attribute(attribute_name)
          [attribute_name, resolve_key(attribute_name)]
        end

        def option_and_false(option)
          option && !resolve_key(option)
        end

        def option_and_true(option)
          option && resolve_key(option)
        end
      end
    end
  end
end
