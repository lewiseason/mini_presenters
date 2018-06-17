describe 'MiniPresenters::Presenter.has_one' do
  let (:subject) { SubjectUnderTest.new }
  let (:subject_has_one_presenter) do
    make_presenter_class do
      attributes :zork, :spam

      def spam
        'spam'
      end
    end
  end

  it 'locates the correct presenter' do
    presenter = make_presenter do
      has_one :subject_has_one
    end

    expect(presenter).to receive(:presenter_from_name).with('SubjectHasOnePresenter') { subject_has_one_presenter }

    expect(presenter.to_h).to eq({ subject_has_one: { zork: 'zork', spam: 'spam' } })
  end

  it 'falls back to the default presenter if none is located' do
    presenter = make_presenter do
      has_one :subject_has_one
    end

    expect(presenter.to_h).to eq({ subject_has_one: { zork: 'zork', gork: 'gork' } })
  end

  context :presenter do
    let(:subject_has_one_presenter) do
      make_presenter_class do
        attributes :unique
        def unique; 'unique'; end
      end
    end

    it '[String] uses the specified presenter name' do
      presenter = make_presenter do
        has_one :subject_has_one, presenter: 'SomePresenter'
      end

      expect(presenter).to receive(:presenter_from_name).with('SomePresenter') { subject_has_one_presenter }

      expect(presenter.to_h).to eq({ subject_has_one: { unique: 'unique' } })
    end

    it '[Object] uses the specified presenter' do
      association_presenter = subject_has_one_presenter

      presenter = make_presenter do
        has_one :subject_has_one, presenter: association_presenter
      end

      expect(presenter.to_h).to eq({ subject_has_one: { unique: 'unique' } })
    end

    it '[Symbol] uses the specified method to find the presenter' do
      presenter = make_presenter do
        has_one :subject_has_one, presenter: :the_presenter

        def the_presenter
          make_presenter_class do
            attributes :unique
            def unique; 'unique'; end
          end
        end
      end

      expect(presenter.to_h).to eq({ subject_has_one: { unique: 'unique' } })
    end
  end

  context :namespace do
    it '[String] uses the specified namespace name' do
      presenter = make_presenter do
        has_one :subject_has_one, namespace: 'Inline'
      end

      expect(presenter).to receive(:presenter_from_name).with('Inline::SubjectHasOnePresenter') { subject_has_one_presenter }

      expect(presenter.to_h).to eq({ subject_has_one: { zork: 'zork', spam: 'spam' } })
    end

    it '[Module] uses the specified namespace' do
      presenter = make_presenter do
        has_one :subject_has_one, namespace: Detailed
      end

      expect(presenter).to receive(:presenter_from_name).with('Detailed::SubjectHasOnePresenter') { subject_has_one_presenter }

      expect(presenter.to_h).to eq({ subject_has_one: { zork: 'zork', spam: 'spam' } })
    end

    it '[Symbol] uses the specified method to find the namespace' do
      presenter = make_presenter do
        has_one :subject_has_one, namespace: :the_namespace

        def the_namespace; 'Inline'; end
      end

      expect(presenter).to receive(:presenter_from_name).with('Inline::SubjectHasOnePresenter') { subject_has_one_presenter }

      expect(presenter.to_h).to eq({ subject_has_one: { zork: 'zork', spam: 'spam' } })
    end
  end

  context :only do
    it 'filters the association keys' do
      presenter = make_presenter do
        has_one :subject_has_one, only: [:zork]
      end

      expect(presenter).to receive(:presenter_from_name).with('SubjectHasOnePresenter') { subject_has_one_presenter }

      expect(presenter.to_h).to eq({ subject_has_one: { zork: 'zork' } })
    end
  end

  context :if do
    it 'accepts a symbol' do
      presenter = make_presenter do
        has_one :subject_has_one, if: :always
        has_one :subject_has_another_one, if: :never

        def always; true; end
        def never; false; end
      end

      expect(presenter).to receive(:presenter_from_name).with('SubjectHasOnePresenter') { subject_has_one_presenter }

      expect(presenter.to_h).to eq({ subject_has_one: { zork: 'zork', spam: 'spam' } })
    end
  end

  context :unless do
    it 'accepts a symbol' do
      presenter = make_presenter do
        has_one :subject_has_one, unless: :always
        has_one :subject_has_another_one, unless: :never

        def always; true; end
        def never; false; end
      end

      expect(presenter).to receive(:presenter_from_name).with('SubjectHasOnePresenter') { subject_has_one_presenter }

      expect(presenter.to_h).to eq({ subject_has_another_one: { zork: 'zork', spam: 'spam' } })
    end
  end
end
