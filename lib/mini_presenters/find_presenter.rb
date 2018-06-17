module MiniPresenters
  module FindPresenter
    def presenter_for(subject, options)
      presenter_class = explicit_presenter(options) ||
                        namespaced_presenter(subject, options) ||
                        suggested_presenter(subject)

      presenter_class.new(subject)
    end

    def presenter_from_name(name)
      Object.const_get(name)
    end

    private

    def explicit_presenter(options)
      klass = options[:presenter]
      return unless klass

      klass = resolve_key(klass) if klass.is_a? Symbol
      klass = presenter_from_name(klass) if klass.is_a? String

      klass
    end

    def namespaced_presenter(subject, options)
      namespace = options[:namespace]
      return unless namespace

      namespace = resolve_key(namespace) if namespace.is_a? Symbol
      presenter_from_name("#{namespace}::#{suggested_presenter_name(subject)}")
    end

    def suggested_presenter(subject)
      presenter_from_name(suggested_presenter_name(subject))
    end

    def suggested_presenter_name(subject)
      "#{subject.class}Presenter"
    end
  end
end
