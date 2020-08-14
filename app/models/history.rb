class History < ApplicationRecord
  
  validates :user_id,{presence:true}
  validates :book_id,{presence:true}
  validates :status,{presence:true}
  
end
