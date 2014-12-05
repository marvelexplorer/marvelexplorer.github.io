require 'date'
require 'twitter'
require 'ultron'
require 'yaml'
require 'dotenv'
require 'fileutils'

Dotenv.load

class MarvelExplorer

  def start_character
    @start_character ||= begin
      File.open ENV['MARSHAL_FILE'] do |file|
        Marshal.load file
      end
    rescue
      Ultron::Characters.find ENV['DEFAULT_ID']
    ensure
      true
    end
  end

  def comic #character
    @comic ||= begin
      comics = Ultron::Comics.by_character_and_vanilla_comics start_character.id
      @comic  = comics.sample
      # some comics have no characters listed, and we need at least 2 to make the game worth playing
      until validate_comic
        @comic = comics.sample
      end
      @comic
    end
  end

  def end_character
    @end_character ||= begin
      characters = Ultron::Characters.by_comic comic.id
      end_character = start_character
      # we want a different character for the next iteration, obvs.
      until end_character.id != start_character.id
        end_character = characters.sample
      end

      end_character
    end
  end

  def save
    File.open ENV['MARSHAL_FILE'], 'w' do |file|
      Marshal.dump end_character, file
    end
  end

  def yamlise
    FileUtils.mkdir_p ENV['YAML_DIR']

    [
      'start',
      'end'
    ].each do |c|
      h = {
        'name' => eval("#{c}_character[:name]"),
        'description' => eval("#{c}_character[:description]"),
        'url' => eval("#{c}_character[:urls][1]['url']"),
        'image' => {
          'path' => eval("#{c}_character[:thumbnail]['path']"),
          'extension' => eval("#{c}_character[:thumbnail]['extension']")
        }
      }

      y = File.open '%s/%s.yml' % [
        ENV['YAML_DIR'],
        c
      ], 'w'
      y.write h.to_yaml
      y.close
    end

    h = {
      'date' => [:dates][0]['date'],
      'title' => comic[:title],
      'url' => comic[:urls][0]['url'],
      'image' => comic[:thumbnail]
    }

    y = File.open '%s/comic.yml' % ENV['YAML_DIR'], 'w'
    y.write h.to_yaml
    y.close
  end

  def validate_comic
    @comic.characters['available'] > 1 &&
    MarvelExplorer.get_year(@comic) > 1900 &&
    @comic.thumbnail['path'] !~ /not_available/
  end

  def self.get_year comic
    DateTime.parse(comic.dates.select { |d| d['type'] == 'onsaleDate' }[0]['date']).year
  end

#  def yamlise
#    h = {}
#    h[:first_character] = @first
#    h[:comic] = @comic
#
#    h[:last_character] = @last
#
#    yaml = File.open '_data/details.yml', 'w'
#    yaml.write h.to_yaml
#    yaml.close
#  end
#
#
#  def perform
#    @first = load
#    @comic = comic @first
#    @last  = last @comic, @first
#
#    @comic.series['name'] =~ /(.*) \((.*)\)/
#    @series = { name: $1, period: $2 }
#
#    yamlise
#  end
#
#  def twitter_client
#    config = {
#      consumer_key:        ENV['TWITTER_CONSUMER_KEY'],
#      consumer_secret:     ENV['TWITTER_CONSUMER_SECRET'],
#      access_token:        ENV['TWITTER_OAUTH_TOKEN'],
#      access_token_secret: ENV['TWITTER_OAUTH_SECRET']
#    }
#    Twitter::REST::Client.new(config)
#  end
#
#  def tweet
#    @tweet_message = 'In %s, %s appeared in %s of the %s run of %s with %s' % [
#        get_year(@comic).to_s,
#        @first.name,
#        'issue #%s' % @comic.issueNumber.to_s,
#        @series[:period],
#        @series[:name],
#        @last.name
#    ]
#    puts @tweet
#
#    if @tweet_message.length > TWEET_LENGTH
#      @tweet_message = '%s…' % s[0, TWEET_LENGTH - 1]
#    end
#
#    puts @tweet_message
#    twitter_client.update @tweet_message
#  end
end

#marvel = MarvelExplorer.new
#marvel.tweet

#message = "#{marvel.tweet_message}"

#`git commit -a -m "#{message}" && git push origin master`
