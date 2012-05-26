class PlayOffPresenter < MatchPresenter
  def home
    !!match.home ? match.home.country : match.handle_no_team(:home)
  end

  def guest
    !!match.guest ? match.guest.country : match.handle_no_team(:guest)
  end
end
