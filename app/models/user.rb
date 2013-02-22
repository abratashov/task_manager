class User < ActiveRecord::Base
  # attr_accessible :title, :body
  authenticates_with_sorcery!

  attr_accessible :email, :password, :password_confirmation

  has_and_belongs_to_many :tasks
  has_many :tasks_users

  #has_many :tasks, through: :tasks_users

  validates_confirmation_of :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
  validates_uniqueness_of :email
end
