require "active_record"

options = {
  adapter: "postgresql",
  database: "globe_db",
}

ActiveRecord::Base.establish_connection(ENV["DATABASE_URL"] || options)
