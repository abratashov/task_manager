class Task < ActiveRecord::Base
  attr_accessible :description

  has_and_belongs_to_many :users

  #has_many :tasks_users

  validates_presence_of :description, :message => 'Description cannot be blank, Task not saved.'
end
