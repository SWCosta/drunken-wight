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

  def no_team_text(group_id, rank)
    # generate text ouptput
    groups = { 0 => "A", 1 => "B", 2 => "C", 3 => "D" }
    ranks = { 0 => "Sieger", 1 => "Zweiplatzierte" }
    of = { 0 => "von", 1 => "aus" }
    "Der #{ranks[rank]} #{of[rank]} Gruppe #{groups[group_id]}"
  end
end
