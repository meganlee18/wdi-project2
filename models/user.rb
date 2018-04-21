class User < ActiveRecord::Base
  has_secure_password
  # gives you 2 methods
  # 1. password
  has_many :messages
end
