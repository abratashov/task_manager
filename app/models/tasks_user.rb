class TasksUser < ActiveRecord::Base
  attr_accessible :sender_id, :task_id, :user_id

  #belongs_to :sender, calss_name: 'User', foreign_key: :sender_id

  # belongs_to :user

  belongs_to :task
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id

  validates_presence_of :task_id, :on => :create
  validates_presence_of :user_id, :on => :create
  validates_presence_of :sender_id, :on => :create
  validates_uniqueness_of :task_id, :scope => :user_id
end
