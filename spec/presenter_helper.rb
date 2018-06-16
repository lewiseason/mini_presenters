class SubjectUnderTest
  def foo; 'foo'; end
  def bar; 'bar'; end
  def baz; 'baz'; end
  def wibble; end
end

def make_presenter(subject = subject, &block)
  klass = Class.new(MiniPresenters::Presenter, &block)
  klass.new(subject)
end
