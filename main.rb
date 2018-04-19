require "sinatra"
require "sinatra/reloader" #comment out before deployment
require "pg"
require "pry"
require "active_record"
require_relative "db_config"

def run_query(sql)
  conn = PG.connect(dbname: "globe_db")
  result = conn.exec(sql)
  conn.close
  return result
end

get "/" do
  sql = "SELECT * FROM photos;"
  @photos = run_query(sql)

  erb :index
end

post "/" do
  erb :new
end

#Must disallow users to post blank fields later!
post "/photos" do
  sql = "INSERT INTO photos (name, image_url, content) VALUES ('#{params[:name]}', '#{params[:image_url]}', '#{params[:content]}');"
  run_query(sql)
  redirect to ("/")
end

delete "/" do
  #sql = "INSERT INTO albums (name, image_url, content) VALUES ('#{params[:album]}', '#{params[:image_url]}', '#{params[:content]}');"
  "DELETE FROM albums WHERE id = #{params[:id]};"

  run_query(sql)
  redirect to ("/")
end

get "/login" do
  erb :login
end

get "/login/signup" do
  erb :signup
end

post "/login/signup" do
  sql = "INSERT INTO users (user_name,email,password_digest) VALUES ('#{params[:name]}', '#{params[:email]}', '#{params[:password]}');"
  #need to change password to authenticate!!!
  run_query(sql)
  redirect to ("/login")
end

post "/session" do
  "welcome back user"
  #redirect to ("/")
end

delete "/session" do
  redirect to("/login")
end

#When user clicks on the photo on homepage, takes them to comment/delete pg
get "/photos/:id" do
  sql = "SELECT * FROM photos WHERE id= #{params[:id]};"
  results = run_query(sql)
  @photo = results.first
  @comments = run_query("SELECT * FROM comments WHERE photo_id = #{params[:id]}")

  erb :show
end

post "/photos/:id" do
  sql = "INSERT INTO comments (content, photo_id) VALUES ('#{params[:content]}', '#{params[:photo_id]}');"
  run_query(sql)
  redirect to("/photos/#{params[:photo_id]}")
end

get "/About" do
  erb :about
end

get "/Contact" do
  erb :contact
end
