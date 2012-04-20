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

  if attempt_to_login
    set_the_cookie
  else
    @error = 'Could not login'
  end

  haml :login
end

def attempt_to_login
  LeanKitKanban::Config.account  = @account 
  LeanKitKanban::Config.email    = @email
  LeanKitKanban::Config.password = @password 

  begin
    LeanKitKanban::Board.all
  rescue
    false
  end
end

def set_the_cookie
  raise 'thanks'
end
