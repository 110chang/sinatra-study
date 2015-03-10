require 'sinatra'
require 'sinatra/reloader'
require 'active_record'
require 'slim'
require 'sass'

set :bind, '192.168.1.11'

ActiveRecord::Base.establish_connection(
  "adapter" => "sqlite3",
  "database" => "./bbs.db"
)

class Comment < ActiveRecord::Base

end


before do
  @title = "Sinatra Study"
end

after do
  logger.info "Success"
end

helpers do
  include Rack::Utils
  alias_method :h, :escape_html
end

get "/" do
  @comments = Comment.order('id desc').all
  slim :index
end

get '/about/?' do
  @title = "About | " + @title
  slim :about
end

post '/new' do
  Comment.create({
    :body => params[:body]
  })
  redirect '/'
end

post '/delete' do
  Comment.find(params[:id]).destroy
  redirect '/'
end

get "/css/com.css" do
  logger.info "SASS"
  sass :'css/com'
end
