describe 'MiniPresenters::Presenter.attributes' do
  let (:subject) { SubjectUnderTest.new }

  it 'includes the corresponding attributes in the result' do
    presenter = make_presenter do
      attributes :foo, :bar
    end

    expect(presenter.to_h).to eq({ foo: 'foo', bar: 'bar' })
  end

  it 'can be invoked multiple times' do
    presenter = make_presenter do
      attributes :foo
      attributes :baz
    end

    expect(presenter.to_h).to eq({ foo: 'foo', baz: 'baz' })
  end

  it 'references local methods if present' do
    presenter = make_presenter do
      attributes :quux
      def quux; 'quux'; end
    end

    expect(presenter.to_h).to eq({ quux: 'quux' })
  end

  it 'prefers local methods to subject methods' do
    presenter = make_presenter do
      attributes :foo
      def foo; 'bar'; end
    end

    expect(presenter.to_h).to eq({ foo: 'bar' })
  end

  it 'does not mess with exceptions on unknown attributes' do
    presenter = make_presenter do
      attributes :flibble
    end

    expect { presenter.to_h }.to raise_exception NoMethodError
  end

  context :if do
    it 'accepts a symbol for :if' do
      presenter = make_presenter do
        attributes :foo, if: :never
        attributes :bar, if: :always

        def never; false; end
        def always; true; end
      end

      expect(presenter.to_h).to eq({ bar: 'bar' })
    end

    it 'falls back to subject methods if no :if defined on presenter' do
      presenter = make_presenter do
        attributes :foo, if: :foo
      end

      expect(presenter.to_h).to eq({ foo: 'foo' })
    end
  end

  context :unless do
    it 'accepts a symbol for :unless' do
      presenter = make_presenter do
        attributes :foo, unless: :always
        attributes :bar, unless: :never

        def never; false; end
        def always; true; end
      end

      expect(presenter.to_h).to eq({ bar: 'bar' })
    end

    it 'falls back to subject methods if no :unless defined on presenter' do
      presenter = make_presenter do
        attributes :foo, unless: :wibble
      end

      expect(presenter.to_h).to eq({ foo: 'foo' })
    end
  end
end
