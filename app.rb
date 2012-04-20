require 'sinatra'
require 'haml'
require 'leankitkanban'

get '/' do
  haml :login
end

post '/' do
  @account = params[:account]
  @email = params[:email]
  @password = params[:password]

  LeanKitKanban::Config.email    = @email
  LeanKitKanban::Config.password = @password 
  LeanKitKanban::Config.account  = @account 

  begin
    LeanKitKanban::Board.all
  rescue
    @error = 'Could not login'
  end

  haml :login
end
