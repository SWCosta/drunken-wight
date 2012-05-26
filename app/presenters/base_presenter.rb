class BasePresenter
  attr_reader :context

  def initialize(object, context, template)
    @object = object
    @context = context
    @template = template
  end

private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @template
  end

  def method_missing(*args, &block)
    @template.send(*args, &block)
  end
end


