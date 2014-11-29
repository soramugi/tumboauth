#!/usr/bin/env ruby
require 'sinatra'
require 'haml'
require 'oauth'

configure do
  enable :sessions
end

get '/' do
  haml :index
end

post '/redirect' do
  consumer = OAuth::Consumer.new(
    params[:consumer],
    params[:secret],
    {
      :site => 'http://www.tumblr.com',
      :request_token_path => '/oauth/request_token',
      :authorize_path => '/oauth/authorize',
      :access_token_path => '/oauth/access_token',
      :http_method => :get
    }
  )
  request_token = consumer.get_request_token(:exclude_callback => true)
  session[:request_token] = request_token
  redirect request_token.authorize_url
end

get '/oauth' do
  request_token = session[:request_token]
  access_token  = request_token.get_access_token(
    :oauth_verifier => params[:oauth_verifier]
  )
  @token        = access_token.token
  @token_secret = access_token.secret
  haml :oauth
end

__END__

@@ layout
%html
  = yield

@@ index
%div.title welcome to the get tumblr oauth

%p 1, get the tumblr apps
%a{:href => 'http://www.tumblr.com/oauth/apps'} http://www.tumblr.com/oauth/apps

%p 2, setting the link
%pre
  Default callback URL:<br />http://127.0.0.1:4567/oauth

%p 3, send the OAuth key
%form{:action=>"/redirect", :method=>"post"}
  OAuth Consumer Key:
  %input{:type=>"texfield",:name=>"consumer"}
  %br
  Secret Key:
  %input{:type=>"texfield",:name=>"secret"}
  %br
  %input{:type=>"submit", :value=>"send"}

@@ oauth

%p access_token
= @token
%p access_token_secret
= @token_secret
