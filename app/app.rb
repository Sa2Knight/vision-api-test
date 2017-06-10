require 'sinatra/base'

class App < Sinatra::Base

  set :views, File.dirname(__FILE__) + '/views'
  set :public_folder, File.dirname(__FILE__) + '/public'

  configure do
    enable :sessions
  end

  get '/' do
    'Hello sinatra'
  end

end
