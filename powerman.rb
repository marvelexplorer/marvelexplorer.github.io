#!/usr/bin/env ruby

require 'dotenv'
require 'curb'
require 'digest'
require 'json'
require 'pp'

Dotenv.load

class Comic
  attr_reader :uri, :issue, :title, :year, :id

  def initialize h
    regex   = /(.*) \(([0-9][0-9][0-9][0-9])\).*/
    matches = regex.match h['title']
    @title  = matches[1]
    @year   = matches[2]
    @issue  = h['issueNumber']
    @id     = h['id']

    @uri = h['resourceURI']
  end

  def to_s
    "%s issue %s, %s" % [
        @title,
        @issue,
        @year
    ]
  end
end

def host
  'http://gateway.marvel.com'
end

def prefix
  'v1/public'
end

def params
  ({
      'limit'     => 50,
      'dateRange' => '1983-01-01,1990-01-01'
  }.map { |k, v| k + '=' + URI.encode(v.to_s) }).join '&'
end

def id
  begin
    (File.read 'last.id').strip
  rescue
    '1009351' # Hulk
  end
end

def write_id id
  File.open 'last.id', 'w' do |f|
    f.write id
  end
end

def auth
  timestamp = Time.new.strftime '%s'

  digest = Digest::MD5.hexdigest '%s%s%s' % [
      timestamp,
      ENV['PRIVATE_KEY'],
      ENV['PUBLIC_KEY']
  ]

  'ts=%s&apikey=%s&hash=%s' % [
      timestamp,
      ENV['PUBLIC_KEY'],
      digest
  ]
end

def fetch url
#  require 'pry'
#  binding.pry

  c         = Curl::Easy.new("%s" % url)
  c.headers = {
      'Accept' => 'application/json'
  }
  c.perform

  h = JSON.parse c.body_str
  h['data']['results']
end

def url path, with_date = true
  params = 'limit=100'
  if with_date
    params = '%s&dateRange=1960-01-01%%2C1990-01-01' % params
  end

  u = '%s/%s/%s?%s&%s' % [
      host,
      prefix,
      path,
      params,
      auth
  ]
end

character = (fetch url 'characters/%s' % [id])[0]

comics = fetch url 'characters/%s/comics' % [id]

comic = Comic.new comics.sample

characters     = fetch url 'comics/%s/characters' % [comic.id], with_date = false
next_character = characters.sample

write_id next_character['id']

puts "%s appeared in %s #%s with %s" % [
    character['name'],
    comic.title,
    comic.issue,
    next_character['name']
]

