require 'open-uri'
require 'net/http'

require 'rubygems'
require 'json'

FOLLOW_URL = 'twitter.com/friendships/create'

def follow_user(screen_name)
  url = URI.parse("http://#{FOLLOW_URL}/#{screen_name}.json")
  puts url
  req = Net::HTTP::Post.new(url.path)
  req.basic_auth @user, @password
  req.set_form_data({})
  Net::HTTP.new(url.host, url.port).start {|http| http.request(req) }
end

@user = ARGV.shift
@password = ARGV.shift

#Follow all of my followers
open('http://twitter.com/statuses/followers.json', :http_basic_authentication=>[@user, @password]) do |f|
  f.readlines.each do |l|
    users = JSON.parse(l)
    users.each do |user|
      begin
        follow_user user["screen_name"]
      rescue Exception => e
        # NO-OP 
      end
    end
  end
end