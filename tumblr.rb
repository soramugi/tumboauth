require "oauth"
require "oauth/consumer"

@consumer = OAuth::Consumer.new(
  'f46z3LB836dipS56AOPsf8y1F4q6yTGjDWl8MYYKnlTBQNeiTX',
  'edavDNi84jqsjaoJ8FbDoo5a3vQCWidJANhgd2218UNCCZK658',
  {site: "https://api.tumblr.com"}
)
@request_token = @consumer.get_request_token

system "open " + @request_token.authorize_url

veri = gets.chomp

@access_token = @request_token.get_access_token(:oauth_verifier => veri)
puts @access_token.token
puts @access_token.secret
