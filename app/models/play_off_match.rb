class PlayOffMatch < Match
  IDS = PlayOffMatch.all.map(&:id)

  belongs_to :following, class_name: "PlayOffMatch"
  has_many :parents, foreign_key: :following_id,
                     class_name: "PlayOffMatch"

  #should be triggered otherwise
  #after_find :set_participants

  def get_default(role)
    role = { home: 0, guest: 1 }[role] if role.is_a? Symbol
    participant(role)
  end

  private

  def set_participants
    if !home && participant(:home).is_a?(Team)
      #set home
      self.home = participant(:home)
      save!
    end
    if !guest && participant(:guest).is_a?(Team)
      #set guest
      self.guest = participant(:guest)
      save!
    end
  end

  def undefined_participant_from_group(group_id,position)
    Struct.new(:group_id, :rank).new(group_id,position)
  end

  def undefined_participant_from_match(match_id)
    Struct.new(:match_id).new(match_id)
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

  def no_team_text(group_id, rank)
    # generate text ouptput
    groups = { 0 => "A", 1 => "B", 2 => "C", 3 => "D" }
    ranks = { 0 => "Sieger", 1 => "Zweiplatzierte" }
    of = { 0 => "von", 1 => "aus" }
    "Der #{ranks[rank]} #{of[rank]} Gruppe #{groups[group_id]}"
  end
end
