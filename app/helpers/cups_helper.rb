module CupsHelper
  def match_caster(match)
    return match.becomes(Match) if request.path =~ /^\/$/
    return :final_match if match.stage.to_param == "finale"
    match
  end

  def query_caster(path,match)
    return { stage_id: match.stage.to_param } if path =~ /^\/$|finale/
    return { group_id: match.stage.to_param } if path =~ /gruppen/
    {}
  end
end
