require 'sinatra/base'
require 'sinatra/flash'
require './lib/hangperson_game.rb'

class HangpersonApp < Sinatra::Base

  enable :sessions
  register Sinatra::Flash
  
  before do
    @game = session[:game] || HangpersonGame.new('')
  end
  
  after do
    session[:game] = @game
  end
  
  get '/' do
    redirect '/new'
  end
  
  get '/new' do
    erb :new
  end
  
  post '/create' do
    word = params[:word] || HangpersonGame.get_random_word
    @game = HangpersonGame.new(word)
    redirect '/show'
  end
  
  post '/guess' do
    letter = params[:guess].to_s[0] || ''
    
    begin
      if !@game.guess(letter)
        flash[:message] = "You have already used that letter"
      end
      if @game.check_win_or_lose == :win
        redirect '/win'
      elsif @game.check_win_or_lose == :lose
        redirect '/lose'
      else 
        redirect '/show'
      end
    rescue ArgumentError
      flash[:message] = "Your input was invalid"
      redirect '/show'
    end
    
    
    
  end
  
  get '/show' do
    erb :show
  end
  
  get '/win' do
    erb :win 
  end
  
  get '/lose' do

    erb :lose
  end
  
end