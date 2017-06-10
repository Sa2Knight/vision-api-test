require 'sinatra/base'
require 'sinatra/reloader'
require_relative './client'

class App < Sinatra::Base

  set :views, File.dirname(__FILE__) + '/views'
  set :public_folder, File.dirname(__FILE__) + '/public'

  configure do
    enable :sessions
  end

  get '/' do
    erb :index
  end

  post '/' do
    # ファイルの存在を確認し、無ければエラーを戻す
    if ! params[:file] || params[:file].empty?
      redirect '/'
    end
    # パラメータをクライアントクラスに投げ、実行結果を戻す
    client = Client.new(params)
    client.get_result
  end

end
