class Book < ApplicationRecord
  validates :name,{presence: true}
  
  def rentaler
    history = History.find_by(status:"rental",book_id: self.id)
    return User.find_by(id: history.user_id).name
  end
  
  def putback_date
    history = History.find_by(status:"rental",book_id: self.id)
    return "#{history.updated_at.advance(days:7).month}月#{history.updated_at.advance(days:7).day}日"
  end
  
end
