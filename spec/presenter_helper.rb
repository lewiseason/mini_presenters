class SubjectUnderTest
  def foo; 'foo'; end
  def bar; 'bar'; end
  def baz; 'baz'; end
  def wibble; end

  def subject_has_one; SubjectHasOne.new; end
  def subject_has_another_one; SubjectHasOne.new; end
  def subject_has_many; [SubjectHasMany.new] * 3; end
end

class SubjectHasOne
  def zork; 'zork'; end
  def gork; 'gork'; end
end

class SubjectHasMany
end

module Detailed
end

def make_presenter_class(&block)
  Class.new(MiniPresenters::Presenter, &block)
end

def make_presenter(subject = subject, &block)
  make_presenter_class(&block).new(subject)
end
