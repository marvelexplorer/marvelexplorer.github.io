[![Dependency Status](http://img.shields.io/gemnasium/pikesley/powerman.png)](https://gemnasium.com/pikesley/powerman)
[![Code Climate](http://img.shields.io/codeclimate/github/pikesley/powerman.png)](https://codeclimate.com/github/pikesley/powerman)
[![License](http://img.shields.io/:license-mit-blue.png)](http://pikesley.mit-license.org)
[![Badges](http://img.shields.io/:badges-4/4-ff6799.png)](https://github.com/pikesley/badger)

# Powerman

Just playing around with the [Marvel API](http://developer.marvel.com/). So:

    git clone https://github.com/pikesley/powerman
    cd powerman
    bundle

You need an API key and secret which you can get from [here](https://developer.marvel.com/signup), put them into `.env` like this

    PUBLIC_KEY: this_r_public_key
    PRIVATE_KEY: this_one_r_private_key
    
Then try `./powerman.rb`:

    ➔ ./powerman.rb
    Hulk appeared in Marvel Comics Presents #38 with Wolverine
    ➔ ./powerman.rb
    Wolverine appeared in Wolverine #10 with Wolverine
    ➔ ./powerman.rb
    Wolverine appeared in Classic X-Men #33 with Cyclops
    ➔ ./powerman.rb
    Cyclops appeared in Classic X-Men #13 with Wolverine
    ➔ ./powerman.rb
    Wolverine appeared in Marvel Comics Presents #10 with Man-Thing

The code is _terrible_, but it's really just an exercise in seeing what can be done with the Marvel API. I think I can make a reasonable Gem out of this…

### Thanks, Twitter

I did want to make a Twitterbot out of this, but **You must add your mobile phone to your Twitter profile before creating an application** now, so that's basically bollocksed that. Thanks, Twitter.
    
