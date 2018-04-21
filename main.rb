require "sinatra"
require "sinatra/reloader" #comment out before deployment
require "pg"
require "pry"
require "active_record"

require_relative "db_config"
require_relative "models/photo"
require_relative "models/comment"
require_relative "models/user"
require_relative "models/message"

enable :sessions

helpers do
  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user ? true : false
  end
end

get "/" do
  @photos = Photo.all
  erb :index
end

post "/" do
  erb :new
end

post "/photos" do
  photo = Photo.new
  photo.name = params[:name]
  photo.image_url = params[:image_url]
  photo.content = params[:content]

  if photo.save
    redirect to("/")
  else
    erb :new
  end
end

delete "/photos/:id" do
  photo = Photo.find(params[:id])
  photo.destroy

  redirect to ("/")
end

get "/login" do
  erb :login
end

get "/login/signup" do
  erb :signup
end

post "/login/signup" do
  #create garbled password
  User.create(email: params[:email],
              user_name: params[:name],
              password: params[:password])

  redirect to ("/login")
end

post "/session" do
  user = User.find_by(email: params[:email])
  if user && user.authenticate(params[:password])
    session[:user_id] = user.id
    redirect to("/")
  else
    erb :login
  end
end

delete "/session" do
  session[:user_id] = nil
  redirect to("/login")
end

#When user clicks on photo, takes them to comment/delete page
get "/photos/:id" do
  @photo = Photo.find(params[:id])
  @comments = @photo.comments

  erb :show
end

post "/photos/:id" do
  comment = Comment.new
  comment.content = params[:content]
  comment.photo_id = params[:photo_id]
  comment.user_id = current_user.id
  comment.save

  redirect to("/photos/#{params[:photo_id]}")
end

get "/About" do
  erb :about
end

get "/Contact" do
  erb :contact
end

post "/messages" do
  message = Message.new
  message.content = params[:content]
  message.user_id = current_user.id
  message.email = current_user.email
  message.save

  redirect to("/")
end

post "/photos/:id/like" do
  Photo.find()
end
