# encoding: utf-8
puts "creating users"
User.create!( :email => "yuszuv@gmx.de",
              :password => "foobar" )

User.create!( :email => "foobar@example.com",
              :password => "foobar" )

puts "creating the cup"
euro2012 = Cup.create! name: "Euro 2012"

puts "creating stages"

groups = {}
("A".."D").each do |char|
  groups[char.to_sym] = Group.create!(name: "#{char}",
                                      cup_id: euro2012.id,
                                      )
end
qf = PlayOff.create! name: "Quarterfinal", cup_id: euro2012.id
sf = PlayOff.create! name: "Semifinal", cup_id: euro2012.id
f = PlayOff.create! name: "Final", cup_id: euro2012.id


puts "creating teams in groups"
teams = ["Poland", "Netherlands", "Spain", "Ukraine", "Greece", "Denmark", "Italy", "Sweden", "Russia", "Germany", "Republic of Ireland", "France", "Czech Republic", "Portugal", "Croatia", "England"]

Group.order('name asc').each.with_index do |group,index|
  index.step( teams.count - 1, 4 ).each do |i|
    group.teams.create! country: teams[i]
  end
end

timetable =<<EOF
8 Jun;	18:00;	Warsaw; POL;	Poland;			Greece;	Group A
8 Jun;	20:45;	Wroclaw; POL;	Russia;			Czech Republic;	Group A
9 Jun;	18:00;	Kharkiv; UKR;	Netherlands;			Denmark;	Group B
9 Jun;	20:45;	Lviv; UKR;	Germany;			Portugal;	Group B
10 Jun;	18:00;	Gdansk; POL;	Spain;			Italy;	Group C
10 Jun;	20:45;	Poznan; POL;	Republic of Ireland;			Croatia;	Group C
11 Jun;	18:00;	Donetsk; UKR;	France;			England;	Group D
11 Jun;	20:45;	Kyiv; UKR;	Ukraine;			Sweden;	Group D
12 Jun;	18:00;	Wroclaw; POL;	Greece;			Czech Republic;	Group A
12 Jun;	20:45;	Warsaw; POL;	Poland;			Russia;	Group A
13 Jun;	18:00;	Lviv; UKR;	Denmark;			Portugal;	Group B
13 Jun;	20:45;	Kharkiv; UKR;	Netherlands;			Germany;	Group B
14 Jun;	18:00;	Poznan; POL;	Italy;			Croatia;	Group C
14 Jun;	20:45;	Gdansk; POL;	Spain;			Republic of Ireland;	Group C
15 Jun;	18:00;	Donetsk; UKR;	Ukraine;			France;	Group D
15 Jun;	20:45;	Kyiv; UKR;	Sweden;			England;	Group D
16 Jun;	20:45;	Warsaw; POL;	Greece;			Russia;	Group A
16 Jun;	20:45;	Wroclaw; POL;	Czech Republic;			Poland;	Group A
17 Jun;	20:45;	Kharkiv; UKR;	Portugal;			Netherlands;	Group B
17 Jun;	20:45;	Lviv; UKR;	Denmark;			Germany;	Group B
18 Jun;	20:45;	Gdansk; POL;	Croatia;			Spain;	Group C
18 Jun;	20:45;	Poznan; POL;	Italy;			Republic of Ireland;	Group C
19 Jun;	20:45;	Kyiv; UKR;	Sweden;			France;	Group D
19 Jun;	20:45;	Donetsk; UKR;	England;			Ukraine;	Group D
EOF

quarterfinals_data =<<EOF
21 Jun;	20:45;	Warsaw; POL;	Group A Winner;			Group B Runner-up;	Quarterfinal
22 Jun;	20:45;	Gdansk; POL;	Group B Winner;			Group A Runner-up;	Quarterfinal
23 Jun;	20:45;	Donetsk; UKR;	Group C Winner;			Group D Runner-up;	Quarterfinal
24 Jun;	20:45;	Kyiv; UKR;	Group D Winner;			Group C Runner-up;	Quarterfinal
EOF

semifinals_data =<<EOF
27 Jun;	20:45;	Donetsk; UKR;	Quarter Final 1 Winner;			Quarter Final 3 Winner;	Semifinal
28 Jun;	20:45;	Warsaw; POL;	Quarter Final 2 Winner;			Quarter Final 4 Winner;	Semifinal
EOF

final_data =<<EOF
1 Jul;	20:45;	Kyiv; UKR;	Semi Final 1 Winner;			Semi Final 2 Winner;	Final
EOF

puts "mapping source data"

groups = Group.scoped.inject({}) do |hash,group|
  hash[group.name.to_sym] = group.id
  hash
end

stages = Stage.scoped.inject({}) do |hash,stage|
  hash[stage.name.to_sym] = stage.id
  hash
end

teams = Team.all.inject({}) do |hash, team|
  #hash[team.country.to_sym] = team.id
  hash[team.country.to_sym] = team
  hash
end

puts "creating the play offs"

def extract_data(line)
  result = []
  data = line.split(";")
  data.map(&:strip!)
  day, month = data[0].split(/ /)
  hour, minute = data[1].split(":")
  result << Time.local(2012, month, day, hour, minute)
  result << data[2]
  result << data[3]
  result << data[4]
  result << data[5]
  result << data[6]
  result
end

#round_of_16 = 8.times.inject([]) do |matches, i|
  
puts "creating the matches in the group period"

text = StringIO.new(timetable)
text.each.with_index do |line,i|
  date, place, country, home, guest, stage = extract_data(line)

  # create models here
  GroupMatch.create! stage_id: stages[stage.sub(/Group /,"").to_sym],
                     slug: (((i%6) %2) + i/8*2 + 1),
                     home: teams[home.to_sym],
                     guest: teams[guest.to_sym],
                     date: date
end

puts "creating playoffs"

Group::IDS = Group.all.map(&:id)

quarterfinals = []
text = StringIO.new quarterfinals_data
text.each.with_index do |line,i|
  date, place, country, home, guest, stage = extract_data(line)
  quarterfinals[i] = PlayOffMatch.create!  stage_id: stages[stage.to_sym],
                                           slug: (((i%6) %2) + i/8*2 + 1),
                                           date: date
end

semifinals = []
text = StringIO.new semifinals_data
text.each.with_index do |line,i|
  date, place, country, home, guest, stage = extract_data(line)
  semifinals << (PlayOffMatch.create!  stage_id: stages[stage.to_sym],
                                       slug: (((i%6) %2) + i/8*2 + 1),
                                       date: date)
end

final = nil
text = StringIO.new final_data
text.each.with_index do |line,i|
  date, place, country, home, guest, stage = extract_data(line)
  final = PlayOffMatch.create!  stage_id: stages[stage.to_sym],
                                slug: (((i%6) %2) + i/8*2 + 1),
                                date: date
end

puts "creating standings"

Group.all.each do |group|
  standing = group.create_standing!
  group.teams.each { |team| standing.results.create! team: team }
end

Cup.all.each do |cup|
  standing = cup.create_standing!
  cup.teams.each { |team| standing.results.create! team: team }
end

puts "creating some match results"

Group.first.matches.each do |match|
  int = proc { ((rand*10).round() - 1)%3}
  match.result = Result.new(int.call, int.call)
  match.save
end
