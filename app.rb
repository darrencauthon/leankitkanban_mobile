require 'sinatra'
require 'haml'
require 'leankitkanban'

enable :sessions

before do
  setup_leankit_api_access_with_values_from session
end

get '/' do
  redirect '/dashboard' if can_access_the_api_with_the_current_config
  haml :login
end

post '/' do
  if the_login_was_successful(params)
    set_the_cookie(params)
    redirect :dashboard
  else
    @error = 'Could not login'
    @account = params[:account]
    @email = params[:email]
    haml :login
  end
end

get '/logoff' do
  session.clear
  redirect '/'
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

def the_login_was_successful(params)
  setup_leankit_api_access_with_values_from params
  can_access_the_api_with_the_current_config
end

def setup_leankit_api_access_with_values_from(values)
  keys_necessary_for_access.each do |key|
    LeanKitKanban::Config.send("#{key}=".to_sym, values[key])
  end
end

def can_access_the_api_with_the_current_config
  begin
    LeanKitKanban::Board.all
    true
  rescue
    false
  end
end

def set_the_cookie(values)
  keys_necessary_for_access.each do |key|
    session[key] = values[key]
  end
end

def keys_necessary_for_access
  [:account, :email, :password]
end
