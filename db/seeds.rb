puts "creating users"
User.create!( :email => "yuszuv@gmx.de",
              :password => "foobar" )

User.create!( :email => "foobar@example.com",
              :password => "foobar" )
