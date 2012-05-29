module CupsHelper
  def match_caster(match)
    return match.becomes(Match) if request.path =~ /^\/$/
    return :play_off_match if match.stage.to_param == "finale"
    match
  end
end
