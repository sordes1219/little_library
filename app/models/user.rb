class User < ApplicationRecord
  
  has_secure_password
  
  validates :name,{presence: true}
  validates :group,{presence: true}
  validates :email,{presence: true,uniqueness: true}
  validates :admin,{presence: true}
  
end
