puts "creating users"
User.create!( :email => "yuszuv@gmx.de",
              :password => "foobar" )

User.create!( :email => "foobar@example.com",
              :password => "foobar" )

puts "creating stages"
("A".."H").each do |char|
  Stage.create! name: "Gruppe #{char}"
end
Stage.create! name: "Achtelfinale"
Stage.create! name: "Viertelfinale"
Stage.create! name: "Halbfinale"
Stage.create! name: "Spiel um Platz 3"
Stage.create! name: "Finale"
