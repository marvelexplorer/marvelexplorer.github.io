#!/usr/bin/env ruby

require 'date'
require 'colorize'
require 'ultron'

DEFAULT_ID   = 1009351 # Hulk
MARSHAL_FILE = 'last.character'

class SixDegrees
  attr_writer :full

  def initialize verbose = nil
    @verbose = verbose
    perform
  end

  def load
    begin
      print 'Unmarshaling start character... ' if @verbose
      File.open MARSHAL_FILE do |file|
        Marshal.load file
      end
    rescue
      print 'No marshaled character found, fetching default... ' if @verbose
      Ultron::Characters.find DEFAULT_ID
    ensure
      puts 'done' if @verbose
    end
  end

  def save character
    print 'Marshaling next character... ' if @verbose
    File.open MARSHAL_FILE, 'w' do |file|
      Marshal.dump character, file
    end
    puts 'done' if @verbose
  end

  def comic character
    print 'Getting comic... ' if @verbose
    comics = Ultron::Comics.by_character_and_vanilla_comics character.id
    comic  = comics.sample
# some comics have no characters listed, and we need at least 2 to make the game worth playing
    until comic.characters['available'] > 1
      comic = comics.sample
    end
    puts 'done' if @verbose

    comic
  end

  def last comic, first
    print 'Getting next character... ' if @verbose
    characters = Ultron::Characters.by_comic comic.id
    last       = first
# we want a different character for the next iteration, obvs.
    until last.id != first.id
      last = characters.sample
    end
    puts 'done' if @verbose

    save last
    last
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
    s << "\n" if @verbose

    s << 'In %s, %s appeared in %s of the %s run of %s with %s' % [
        DateTime.parse(@comic.dates.select { |d| d['type'] == 'onsaleDate' }[0]['date']).year.to_s.colorize(:cyan),
        @first.name.colorize(:green),
        'issue #%s'.colorize(:red) % @comic.issueNumber.to_s,
        @series[:period].colorize(:light_blue),
        @series[:name].colorize(:magenta),
        @last.name.colorize(:white)
    ]


    if @verbose
      s << "\n"
      s << @comic.urls.select { |c| c['type'] == 'detail' }[0]['url'].split('?')[0].colorize(:yellow)
      s << "\n"
      s << "\n"

      [@first, @comic, @last].each do |i|
        s << i.resourceURI
        s << "\n"
      end
    end

    s
  end
end

s = SixDegrees.new ARGV.count > 0
puts s


