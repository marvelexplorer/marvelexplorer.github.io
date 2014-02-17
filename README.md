[![Dependency Status](http://img.shields.io/gemnasium/pikesley/powerman.png)](https://gemnasium.com/pikesley/powerman)
[![Code Climate](http://img.shields.io/codeclimate/github/pikesley/powerman.png)](https://codeclimate.com/github/pikesley/powerman)
[![License](http://img.shields.io/:license-mit-blue.png)](http://pikesley.mit-license.org)
[![Badges](http://img.shields.io/:badges-4/4-ff6799.png)](https://github.com/pikesley/badger)

# Powerman

A silly application built on my [Ultron](http://pikesley.github.io/ultron/) gem (which wraps the [Marvel Comics API](http://developer.marvel.com/)). The code's pretty crappy, and it has no tests, but it's just a toy:

    git clone https://github.com/pikesley/powerman
    cd powerman
    bundle

You need an API key and secret which you can get from [here](https://developer.marvel.com/signup), put them into `.env` like this

    PUBLIC_KEY: this_r_public_key
    PRIVATE_KEY: this_one_r_private_key
    
Then try `./powerman.rb`:

    ➔ ./powerman.rb
    In 2007, Hulk appeared in issue #5 of the 2007 run of World War Hulk: Front Line with Sentry (Robert Reynolds)
    ➔ ./powerman.rb
    In 2006, Sentry (Robert Reynolds) appeared in issue #0 of the 2006 run of New Avengers Vol.2: Sentry with Emma Frost
    ➔ ./powerman.rb
    In 2005, Emma Frost appeared in issue #10 of the 2004 - 2008 run of New X-Men with X-Men
    ➔ ./powerman.rb
    In 1983, X-Men appeared in issue #173 of the 1963 - 2011 run of Uncanny X-Men with Havok
    
Right now, it just wanders aimlessly through the data. I'd like to make it more directed so I could make some sort of _6 Degrees Of Deadpool_ or calculate a given character's [Wolverine Number](http://en.wikipedia.org/wiki/Erd%C5%91s_number) or something like that. Any ideas?
    
### Thanks, Twitter

I did want to make a Twitterbot out of this, but **You must add your mobile phone to your Twitter profile before creating an application** now, so that's basically bollocksed that. Thanks, Twitter.
