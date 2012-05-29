module CupsHelper
  def match_caster(match)
    return match.becomes(Match) if request.path =~ /^\/$/
    return :final_match if match.stage.to_param == "finale"
    match
  end
end
