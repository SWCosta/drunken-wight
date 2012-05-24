# encoding: utf-8
puts "creating users"
User.create!( :email => "yuszuv@gmx.de",
              :password => "foobar" )

User.create!( :email => "foobar@example.com",
              :password => "foobar" )

puts "creating stages"
("A".."D").each do |char|
  Stage.create! name: "Gruppe #{char}"
end
Stage.create! name: "Achtelfinale"
Stage.create! name: "Viertelfinale"
Stage.create! name: "Halbfinale"
Stage.create! name: "Spiel um Platz 3"
Stage.create! name: "Finale"

puts "creating the cup"
euro2012 = Cup.create! name: "Euro 2012"

puts "creating teams in groups"
teams = ["Polen", "Niederlande", "Spanien", "Ukraine", "Griechenland", "Dänemark", "Italien", "Schweden", "Russland", "Deutschland", "Irland", "Frankreich", "Tschechien", "Portugal", "Kroatien", "England"]
Stage.where("name like 'Gruppe%'").order('name asc').each.with_index do |group,index|
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

groups = Stage.where("NAME like 'Gruppe%'").inject({}) do |hash,group|
  hash[group.name.sub(/Gruppe/,"Group").to_sym] = group.id
  hash
end

teams = Team.all.inject({}) do |hash, team|
  hash[team.country.to_sym] = team.id
  hash
end


text = StringIO.new(timetable)
text.each do |line|
  data = line.split(";")
  data.map(&:strip!)
  day, month = data[0].split(/ /)
  hour, minute = data[1].split(":")
  date = Time.local(2012, month, day, hour, minute)
  place = data[2]
  country = data[3]
  home = data[4]
  guest = data[5]
  group = data[6]

  # create models here
  Match.create! cup: euro2012,
                stage_id: groups[group.to_sym],
                home_id: teams[I18n.t("countries.#{home.parameterize}").to_sym],
                guest_id: teams[I18n.t("countries.#{guest.parameterize}").to_sym],
                date: date
end
