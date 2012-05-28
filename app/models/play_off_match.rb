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
    case stage.name
    when "Quarterfinal"
      group_index, position = stage.cup.quarterfinal_mapping(index, role)
      group = Group.where(id: Group::IDS).reorder(:id)[group_index]
      group.has_finished? ? group.results[position].team : undefined_participant_from_group(group_index, position)
    when "Semifinal", "Final"
      match_count = (stage.name == "Final") ? 1 : 2
      pre_stage_index = stage.cup.finals_mapping(index, role, match_count)
      pre_stage = (stage.name == "Final") ? PlayOff.find_by_name("Semifinal") : PlayOff.find_by_name("Quarterfinal")
      #playoff = PlayOff.where(id: PlayOff::IDS).reorder(:id)[pre_stage_index]
      pre_match = Match.where(stage_id: pre_stage.id).reorder(:date).select("id")[pre_stage_index]
      pre_match.winner || undefined_participant_from_match(pre_match.id)
    end
  end

  private

  def undefined_participant_from_group(group_id,position)
    Struct.new(:group_id, :rank).new(group_id,position)
  end

  def undefined_participant_from_match(match_id)
    Struct.new(:match_id).new(match_id)
  end

end
