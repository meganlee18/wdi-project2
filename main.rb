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
  def has_warning?
    @warning ? true : false
  end

  def current_user
    User.find_by(id: session[:user_id])
  end

  def logged_in?
    current_user ? true : false
  end
end

get "/" do
  if logged_in?
    @photos = Photo.all
    erb :index
  else
    erb :login
  end
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
    @warning = "Unable to upload your image. Image name needs to be more than 6 characters. Image URL needs to be less than 400 characters."
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
  user = User.find_by(user_name: params[:name])
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
  if logged_in?
    erb :contact
  else
    @warning = "Please log in before accessing this page"
    erb :login
  end
end

post "/messages" do
  message = Message.new
  message.content = params[:content]
  message.user_id = current_user.id
  message.email = current_user.email

  if message.save
    redirect to("/")
  else
    @warning = "Message cannot be empty!"
    erb :contact
  end
end

post "/photos/:id/like" do
  @photo = Photo.find(params[:id])
  like_count = @photo.like + 1
  @photo.update(like: like_count)
  redirect to("/photos/#{params[:id]}")
end
