#!/usr/bin/env ruby

require 'date'
require 'twitter'
require 'ultron'
require 'yaml'

DEFAULT_ID   = 1009351 # Hulk
MARSHAL_FILE = 'last.character'
TWEET_LENGTH = 140

class MarvelExplorer
  attr_writer :full

  def initialize
    perform
  end

  def load
    begin
      File.open MARSHAL_FILE do |file|
        Marshal.load file
      end
    rescue
      Ultron::Characters.find DEFAULT_ID
    ensure
      true
    end
  end

  def save character
    File.open MARSHAL_FILE, 'w' do |file|
      Marshal.dump character, file
    end
  end

  def comic character
    comics = Ultron::Comics.by_character_and_vanilla_comics character.id
    comic  = comics.sample
# some comics have no characters listed, and we need at least 2 to make the game worth playing
    until comic.characters['available'] > 1 && get_year(comic) > 1900 && comic.thumbnail['path'] !~ /not_available/
      comic = comics.sample
    end

    comic
  end

  def last comic, first
    characters = Ultron::Characters.by_comic comic.id
    last       = first
# we want a different character for the next iteration, obvs.
    until last.id != first.id
      last = characters.sample
    end

    h = {}
    h[:first_character] = first
    h[:comic] = comic

    h[:last_character] = last

    yaml = File.open '_data/details.yml', 'w'
    yaml.write h.to_yaml
    yaml.close

    save last
    last
  end

  def get_year comic
    DateTime.parse(comic.dates.select { |d| d['type'] == 'onsaleDate' }[0]['date']).year
  end

  def perform
    @first = load
    @comic = comic @first
    @last  = last @comic, @first

    @comic.series['name'] =~ /(.*) \((.*)\)/
    @series = { name: $1, period: $2 }
  end

  def to_s
    s = ''

    s << 'In %s, %s appeared in %s of the %s run of %s with %s' % [
        get_year(@comic).to_s,
        @first.name,
        'issue #%s' % @comic.issueNumber.to_s,
        @series[:period],
        @series[:name],
        @last.name
    ]

    if s.length > TWEET_LENGTH
      s = '%s…' % s[0, TWEET_LENGTH - 1]
    end

    s
  end
end

config = {
  consumer_key:        ENV['TWITTER_CONSUMER_KEY'],
  consumer_secret:     ENV['TWITTER_CONSUMER_SECRET'],
  access_token:        ENV['TWITTER_OAUTH_TOKEN'],
  access_token_secret: ENV['TWITTER_OAUTH_SECRET']
}

client = Twitter::REST::Client.new(config)

marvel = MarvelExplorer.new

puts marvel
#client.update marvel

message = "#{marvel.to_s}"

`git pull ; git commit -a -m "#{message}" ; GIT_SSH=~/sshv.sh git push origin master`
