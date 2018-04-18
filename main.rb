require "sinatra"
require "pg"
require "pry"
require "active_record"
require_relative "db_config"

get "/" do
  erb :index
end

get "/login" do
  erb :login
end

get "/signup" do
  erb :signup
end

get "/new" do
  erb :new
end

post "/session" do
end

delete "/session" do
end
