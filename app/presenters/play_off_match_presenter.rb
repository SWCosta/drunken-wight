class PlayOffMatchPresenter < MatchPresenter
  def home
    !!match.home ? match.home.country : handle_no_team(match,:home)
  end

  def guest
    !!match.guest ? match.guest.country : handle_no_team(match,:guest)
  end

  def handle_no_team(match,role)
    alt = match.get_default(role)
    if alt.respond_to? :group_id
      if alt.rank == 0
        "Der Sieger von Gruppe #{match.stage.cup.stages.find(alt.group_id).name}"
      else
        "Der Zweitplatzierte aus Gruppe #{match.stage.cup.stages.find(alt.group_id).name}"
      end
    else
      "Der Sieger aus dem #{Stage.find(alt.stage).name.humanize} #{alt.match_id}"
    end
  end
end
