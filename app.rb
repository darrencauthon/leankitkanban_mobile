require 'sinatra'
require 'haml'
require 'leankitkanban'

enable :sessions

before do
  LeanKitKanban::Config.account  = session[:account] 
  LeanKitKanban::Config.email    = session[:email] 
  LeanKitKanban::Config.password = session[:password]
end

get '/' do
  haml :login
end

post '/' do
  @account = params[:account]
  @email = params[:email]
  @password = params[:password]

  if attempt_to_login
    set_the_cookie
    redirect :dashboard
  else
    @error = 'Could not login'
    haml :login
  end

end

get '/dashboard' do
  @boards = LeanKitKanban::Board.all[0]
  @boards.sort!{|a,b| a["Title"].to_s.downcase <=> b["Title"].to_s.downcase}
  haml :dashboard
end

get '/board/:board_id/card/:card_id' do
  @board_id = params[:board_id]
  @card = LeanKitKanban::Card.find(params[:board_id], params[:card_id])[0]
  haml :card
end

get '/board/:id' do
  @board = LeanKitKanban::Board.find(params[:id])[0]
  @lanes = @board["Lanes"]
  haml :board
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
  session[:account]  = @account 
  session[:email]    = @email 
  session[:password] = @password
end
