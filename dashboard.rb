require 'sinatra/base'
require 'leankitkanban'

class Dashboard < Sinatra::Base
  get '/dashboard' do
    @boards = LeanKitKanban::Board.all[0]
    @boards.sort_by!{ |b| b["Title"].to_s.downcase }
    haml :dashboard
  end
end
