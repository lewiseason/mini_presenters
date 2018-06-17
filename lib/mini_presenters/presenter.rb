require 'mini_presenters/find_presenter'

require 'mini_presenters/keys/attributes'
require 'mini_presenters/keys/has_one'

module MiniPresenters
  class Presenter
    include MiniPresenters::FindPresenter
    include MiniPresenters::Keys::Attributes
    include MiniPresenters::Keys::HasOne

    def initialize(subject, options = {})
      @subject = subject
      @options = options
    end

    def to_h
      {}.merge(**attributes_hash, **has_one_associations_hash)
    end

    def resolve_key(key)
      return send(key) if respond_to?(key)

      @subject.send(key)
    end

    def self.extract_options!(args)
      return [args, {}] unless args.last.is_a?(Hash)

      opts = args.pop
      [args, opts]
    end
  end
end
