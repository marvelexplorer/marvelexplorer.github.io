#!/usr/bin/env ruby

require 'dotenv'
require 'curb'
require 'digest'
require 'json'
require 'pp'

Dotenv.load

timestamp = Time.new.strftime '%s'
digest    = Digest::MD5.hexdigest '%s%s%s' % [
    timestamp,
    ENV['PRIVATE_KEY'],
    ENV['PUBLIC_KEY']
]

host   = 'http://gateway.marvel.com'
path   = 'v1/public/characters'
params = '?limit=1&name=%s' % URI.encode(ARGV[0])
auth   = 'ts=%s&apikey=%s&hash=%s' % [
    timestamp,
    ENV['PUBLIC_KEY'],
    digest
]

url = '%s/%s%s&%s' % [
    host,
    path,
    params,
    auth
]

c         = Curl::Easy.new("%s" % url)
c.headers = {
    'Accept' => 'application/json'
}
c.perform

h = JSON.parse c.body_str
pp h['data']['results'][0]