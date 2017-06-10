require 'sinatra/base'
require_relative './client'
require 'rack/flash'

class App < Sinatra::Base

  set :views, File.dirname(__FILE__) + '/views'
  set :public_folder, File.dirname(__FILE__) + '/public'

  configure do
    enable :sessions
    use Rack::Flash
  end

  get '/' do
    erb :index
  end

  post '/' do
    # ファイルの存在を確認し、無ければエラーを戻す
    if ! params[:file] || params[:file].empty?
      @err = 'ファイルを選択してください'
      return erb :index
    end
    # パラメータをクライアントクラスに投げ、実行結果を戻す
    client = Client.new(params)
    if landmarks = client.landmark_detection
      @landmarks = landmarks
      @filepath = client.save
    else
      @err = 'ランドマークが見つかりませんでした'
    end
    erb :index
  end

end
