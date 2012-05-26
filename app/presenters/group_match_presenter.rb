class GroupMatchPresenter < MatchPresenter
  def home
    match.home.country
  end
end
