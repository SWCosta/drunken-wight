module CupsHelper
  def match_caster(match)
    return match.becomes(Match) if request.path =~ /^\/$/
    return :final_match if match.stage.to_param == "finale"
    match
  end

  def show_match_caster(match)
    return match_path(match.becomes(Match),stage_id: request.query_parameters[:stage_id]) if request.path =~ /spiele/
    return group_match_path(params[:group_id],match) if request.path =~ /^\/gruppen/
    return play_off_match_path(params[:stage_id],match) if request.path =~ /^\/\w+finale\//
    return play_off_path(match.stage) if request.path =~ /^\/finale/
    match
  end

  def edit_match_caster(match)
    return match_path(match.becomes(Match),stage_id: params[:stage_id]) if request.path =~ /spiele/
    return group_match_path(match.becomes(GroupMatch), group_id: params[:stage_id]) if request.path =~ /^\/gruppen/
    return play_off_match_path(match.becomes(PlayOffMatch), stage_id: params[:stage_id]) if request.path =~ /^\/\w+finale/
    return play_off_match_path(stage_id: params[:stage_id], id: 1) if request.path =~ /^\/finale/
    match
  end

  def query_caster(path,match)
    return { stage_id: match.stage.to_param } if path =~ /^\/$|finale/
    return { group_id: match.stage.to_param } if path =~ /^\/gruppen/
    {}
  end

  def match_type_caster(match)
    match.becomes(Match)
  end
end
