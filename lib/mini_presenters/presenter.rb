require 'mini_presenters/presenters/attributes'

module MiniPresenters
  class Presenter
    include MiniPresenters::Presenters::Attributes

    def initialize(subject)
      @subject = subject
    end

    def to_h
      {}.merge(**attributes_hash)
    end

    def resolve_key(key)
      return send(key) if respond_to?(key)

      @subject.send(key)
    end
  end
end
