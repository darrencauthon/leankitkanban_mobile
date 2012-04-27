require 'sinatra/base'
require 'haml'
require 'leankitkanban'

class Authorization < Sinatra::Base

  configure do |config|
    enable :sessions
  end

  before do
    setup_leankit_api_access_with_values_from session
    redirect '/' if on_a_secure_page_but_not_logged_in?
  end

  get '/' do
    redirect '/dashboard' if logged_in?
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

  def the_login_was_successful(params)
    setup_leankit_api_access_with_values_from params
    logged_in?
  end

  def setup_leankit_api_access_with_values_from(values)
    puts values.inspect
    keys_necessary_for_access.each do |key|
      LeanKitKanban::Config.send("#{key}=".to_sym, values[key])
    end
  end

  def logged_in?
    begin
      LeanKitKanban::Board.all
      true
    rescue
      false
    end
  end

  def on_a_secure_page_but_not_logged_in?
    return false if request.path_info == '/'
    !logged_in?
  end

  def set_the_cookie(values)
    keys_necessary_for_access.each do |key|
      session[key] = values[key]
    end
  end

  def keys_necessary_for_access
    [:account, :email, :password]
  end
end
