class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me

  validates :email, presence: true, uniqueness: true

  has_many :stocks

  def portfolio
    Portfolio.new(stocks)
  end

end
