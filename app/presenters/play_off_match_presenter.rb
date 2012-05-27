class PlayOffMatchPresenter < MatchPresenter
  def home
    !!match.home ? match.home.country : handle_no_team(match,:home)
  end

  def guest
    !!match.guest ? match.guest.country : handle_no_team(match,:guest)
  end

  def handle_no_team(match,role)
    match.get_default(role)
  end
end
