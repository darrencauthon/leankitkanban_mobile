require 'sinatra'
require 'haml'

get '/' do
  haml :login
end

post '/' do
  @account = params[:account]
  @email = params[:email]
  @error = "Uh oh!"
  haml :login
end
