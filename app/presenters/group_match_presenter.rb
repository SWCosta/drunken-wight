class GroupMatchPresenter < MatchPresenter
  def home
    match.home.country
  end

  def guest
    match.guest.country
  end
end
