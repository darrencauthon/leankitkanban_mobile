require 'sinatra/base'

class Board < Sinatra::Base
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
end
