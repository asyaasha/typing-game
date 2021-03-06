class User < ActiveRecord::Base
  has_secure_password
  has_many :games

  before_save {self.email = email.downcase}
  validates :username, {presence: true, uniqueness: true, length: {maximum: 25}}
  validates :email, {presence: true, length:{maximum: 105}, uniqueness: true}

  def high_score
    games.order(Game.arel_table['score'].desc).limit(1).first.score
  end

  def average_wpm
    recent_wpm = most_recent_games.map { |game| game.wpm }
    (recent_wpm.reduce(:+) / recent_wpm.length)
  end

  def average_accuracy
    recent_accuracy = most_recent_games.map { |game| game.accuracy }
    (recent_accuracy.reduce(:+) / recent_accuracy.length)
  end

  def most_recent_games
    games.order(Game.arel_table['created_at'].desc).limit(10)
  end
end
