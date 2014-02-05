[![Dependency Status](http://img.shields.io/gemnasium/pikesley/powerman.svg)](https://gemnasium.com/pikesley/powerman)
[![Code Climate](http://img.shields.io/codeclimate/github/pikesley/powerman.svg)](https://codeclimate.com/github/pikesley/powerman)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://pikesley.mit-license.org)
[![Badges](http://img.shields.io/:badges-4/4-ff6799.svg)](https://github.com/pikesley/badger)

#Powerman

Just playing around with the [Marvel API](http://developer.marvel.com/). So:

    git clone https://github.com/pikesley/powerman
    cd power man
    bundle

You need an API key and secret which you can get from [here](https://developer.marvel.com/signup), put them into `.env` like this

    PUBLIC_KEY: this_r_public_key
    PRIVATE_KEY: this_one_r_private_key
    
Then try `./powerman.rb "Spider-man"` to get back a shitload of Spider-man-related JSON:

    ➔ ./powerman.rb "Spider-man"
    {"id"=>1009610,
     "name"=>"Spider-Man",
     "description"=>
      "Bitten by a radioactive spider, high school student Peter Parker gained the speed, strength and powers of a spider. Adopting the name Spider-Man, Peter hoped to start a career using his new abilities. Taught that with great power comes great responsibility, Spidey has vowed to use his powers to help people.",
    etc, etc
    
Marvel's naming seems very inconsistent, for example:

    ➔ ./powerman.rb "Dr. Doom"
    nil
    ➔ ./powerman.rb "Doctor Doom"
    {"id"=>1009281,
     "name"=>"Doctor Doom",
      
but

    ➔ ./powerman.rb "Mister Fantastic"
    nil
    ➔ ./powerman.rb "Mr. Fantastic"
    {"id"=>1009459,
     "name"=>"Mr. Fantastic",
     
I guess these are the canonical names, or I've misunderstood something.

Anyway, that's all I got for now, maybe I'll cook up some sort of _6-degrees-of-Deadpool_ or something.