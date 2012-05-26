class PlayOff < Match

  belongs_to :following, class_name: "PlayOff"
  has_many :parents, foreign_key: :following_id,
                     class_name: "PlayOff"

#  after_find :set_participants

#  def handle_no_team(role)
#    roles = { home: 0, guest: 1 }
#    if self.parents.present? #semifinals, final
#      # 1/4 finals or 1/2 finals
#      #group = self.p
#      "Sieger von "
#    else #quarterfinals
#      #groups
#      # where am i?
#      x = Stage.find(self.stage.id).matches.reorder(:date).index(self)
#      y = roles[role]
#      group, rank = cup.quarterfinal_mapping(x,y)
#      participant(group, rank) || no_team_text(group, rank)
#    end
#  end
#
#  private
#
#  def set_participants
#    if !home
#      #set home
#      self.home = participant(:home)
#    end
#    if !guest
#      self.guest = participant(:guest)
#      puts "setting guest"
#      #set guest
#    end
#  end
#
#  def undefined_participant
#    Struct.new(:group, :rank)
#  end
#
#  def participant(role)
#    role = { home: 0, guest: 1 }[role] if role.is_a? Symbol
#    index = stage.matches.reorder(:date).index(self)
#    case stage.name
#    when "Quarterfinal"
#      group_id, position = cup.quarterfinal_mapping(index, role)
#      group = Stage.where(id: Stage::GROUPS).reorder(:id)[group_id]
#      group.has_finished? ? group.standings[position].team : undefined_participant(group_id, position)
#    when "Semifinal", "Final"
#      #
#    end
#  end

#  def participant(group_id, rank)
#    # check is the winner or runner-up already exists
#    no = { 0 => :winner, 1 => :runner_up }[rank]
#    group = Stage.where(id: Stage::GROUPS).reorder(:id)[group_id]
#    #group.has_a?(no) ? group.get_the(no) : no_team_text(group_id, rank)
#    group.has_a?(no) ? group.get_the(no) : undefined_participant.new(group_id, rank)
#  end

  def no_team_text(group_id, rank)
    # generate text ouptput
    groups = { 0 => "A", 1 => "B", 2 => "C", 3 => "D" }
    ranks = { 0 => "Sieger", 1 => "Zweiplatzierte" }
    of = { 0 => "von", 1 => "aus" }
    "Der #{ranks[rank]} #{of[rank]} Gruppe #{groups[group_id]}"
  end
end
