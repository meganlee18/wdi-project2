require "sinatra"
require "pg"
require "pry"
require_relative "active_record"
require_relative "db_config.rb"

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
