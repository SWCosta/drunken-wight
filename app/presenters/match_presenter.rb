# encoding: utf-8

class MatchPresenter < BasePresenter
  presents :match
  
  def date
    match.date.strftime("%d.%m")
  end

  def time
    match.date.strftime("%H:%M")
  end

  def home_score
    match.home_score || "•"
  end

  def guest_score
    match.guest_score || "•"
  end

private

  def handle_none(value)
    if value.present?
      yield
    else
      h.content_tag :span, "None given", class: "none"
    end
  end

end


