[![Dependency Status](http://img.shields.io/gemnasium/pikesley/marvel_explorer.svg)](https://gemnasium.com/pikesley/marvel_explorer)
[![Code Climate](http://img.shields.io/codeclimate/github/pikesley/marvel_explorer.svg)](https://codeclimate.com/github/pikesley/marvel_explorer)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://pikesley.mit-license.org)
[![Badges](http://img.shields.io/:badges-4/4-ff6799.svg)](https://github.com/pikesley/badger)

#Marvel Explorer

A silly application built on my [Ultron](http://pikesley.github.io/ultron/) gem (which wraps the [Marvel Comics API](http://developer.marvel.com/)). The code's _very_ crappy, and it has no tests, but it works:

    git clone https://github.com/pikesley/marvel_explorer
    cd marvel_explorer
    bundle

You need an API keypair which you can get from [here](https://developer.marvel.com/signup), put them into `.env` like this

    PUBLIC_KEY: this_r_public_key
    PRIVATE_KEY: this_one_r_private_key

and it seems you [*can* now build Twitter bots without needing a phone number for each one](http://dghubble.com/blog/posts/twitter-app-write-access-and-bots/), so my `.env` also has

    TWITTER_CONSUMER_KEY: a_key
    TWITTER_CONSUMER_SECRET: a_secret
    TWITTER_OAUTH_TOKEN: a_token
    TWITTER_OAUTH_SECRET: a_nuvver_secret

It [Tweets](https://twitter.com/marvel_explorer) and generates a [Github Pages site](http://marvelexplorer.github.io/)
