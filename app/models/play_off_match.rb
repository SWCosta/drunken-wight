class PlayOffMatch < Match
  IDS = PlayOffMatch.all.map(&:id)

  belongs_to :following, class_name: "PlayOffMatch"
  has_many :parents, foreign_key: :following_id,
                     class_name: "PlayOffMatch"

  def get_default(role)
    role = { home: 0, guest: 1 }[role] if role.is_a? Symbol
    participant(role)
  end

  def participant(role)
    role = { home: 0, guest: 1 }[role] if role.is_a? Symbol
    index = Match.where(stage_id: self.stage_id).reorder(:date).select("id").map(&:id).index(self.id)
    case stage.to_param
    when "viertelfinale" then
      #debugger
      cup_id, group_index, position = stage.cup.to_param, *stage.cup.quarterfinal_mapping(index, role)
      group = stage.cup.groups.reorder(:slug)[group_index]
      group.has_finished? ? group.results[position].team : undefined_participant_from_group(cup_id, group.to_param, position)
    when "halbfinale", "finale" then
      match_count = (stage.to_param == "finale") ? 1 : 2
      cup_id, pre_stage_index = stage.cup.to_param, *stage.cup.finals_mapping(index, role, match_count)
      pre_stage = (stage.to_param == "finale") ? stage.cup.stages.find("halbfinale") : stage.cup.stages.find("viertelfinale")
      pre_match = Match.where(stage_id: pre_stage.id).reorder(:date)[pre_stage_index]
      pre_match.winner || undefined_participant_from_match(cup_id, pre_stage.to_param, pre_stage_index+1)
    end
  end

  private

  def undefined_participant_from_group(cup_id, group_id,position)
    Struct.new(:cup_id, :group_id, :rank).new(cup_id, group_id,position)
  end

  def undefined_participant_from_match(cup_id, stage, match_id)
    Struct.new(:cup_id, :stage, :match_id).new(cup_id, stage, match_id)
  end

end
