#!/usr/bin/env ruby

require 'ultron'

def id
  begin
    (File.read 'last.id').strip
  rescue
    '1009351' # Hulk
  end
end

def write_id id
  File.write 'last.id', id.to_s
end

print 'Getting start character... '
character = Ultron::Characters.find id
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

puts
puts '%s appeared in %s with %s' % [character.name, comic.title, next_character.name]
puts '[%s]' % comic.urls.select { |c| c['type'] == 'detail' }[0]['url']

puts
puts character.resourceURI
puts comic.resourceURI
puts next_character.resourceURI

write_id next_character.id
