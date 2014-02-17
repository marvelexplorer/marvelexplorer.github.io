#!/usr/bin/env ruby

require 'ultron'

class SixDegrees
  attr_writer :full

  def initialize first, link, last
    @first = first
    @link = link
    @last = last
  end

  def to_s
    s = '%s appeared in %s with %s' % [
        @first.name,
        @link.title,
        @last.name
    ]

    if @full
      s << ''
      s << @link.urls.select { |c| c['type'] == 'detail' }[0]['url']
      s << ''
      s << @first.resourceURI
      s << @link.resourceURI
      s << @last.resourceURI
    end

    s
  end
end

def retrieve
  begin
    File.open 'last.character' do |file|
      Marshal.load file
    end
  rescue
    Ultron::Characters.find 1009351
  end
end

def commit character
  File.open 'last.character', 'w' do |file|
    Marshal.dump character, file
  end
end

print 'Getting start character... '
character = retrieve
puts 'done'

print 'Getting comic... '
comics = Ultron::Comics.by_character character.id
comic  = comics.sample
# some comics have no characters listed, and we need at least 2 to make the game worth playing
until comic.characters['available'] > 1
  comic = comics.sample
end
puts 'done'

print 'Getting next character... '
characters     = Ultron::Characters.by_comic comic.id
next_character = character
# we want a different character for the next iteration, obvs.
until next_character.id != character.id
  next_character = characters.sample
end
puts 'done'

s = SixDegrees.new character, comic, next_character
puts s

commit next_character

