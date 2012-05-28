module ApplicationHelper
  def link_to_country(name,align="left")
    align = align.to_sym
    output = ""
    begin
      output += icon("countries",name) if align == :left
    rescue
    end
    output += name
    begin
      output += icon("countries",name) if align == :right
    rescue
      output
    end
    output.html_safe
  end

  def icon(namespace=nil,name)
    content_tag :i, :class => [namespace,name.parameterize].join("-") do; end
  end

  def country_image(name)
    image_tag File.join("countries", name.parameterize+".png")
  end

  def present(object, context = :collection, klass = nil)
    klass ||= "#{object.class}Presenter".constantize
    context.in?(:collection, :member) || (context = :collection)
    presenter = klass.new(object, context, self)
    yield presenter if block_given?
    presenter
  end
end
