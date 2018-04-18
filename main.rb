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
  erb :index
end

post "/" do
  erb :new
end

post "/albums" do
  sql = "INSERT INTO albums (name, image_url, content) VALUES ('#{params[:album]}', '#{params[:image_url]}', '#{params[:content]}');"
  run_query(sql)
  redirect to ("/")
end

delete "/" do
  "Are you sure you want to delete this album?"
end

get "/login" do
  erb :login
end

get "/login/signup" do
  erb :signup
end

post "/login/signup" do
  sql = "INSERT INTO users (user_name,email,password) VALUES ('#{params[:name]}', '#{params[:email]}', '#{params[:password]}');"
  run_query(sql)
  redirect to ("/login")
end

post "/session" do
  "Hello User"
end

delete "/session" do
  redirect to("/login")
end
