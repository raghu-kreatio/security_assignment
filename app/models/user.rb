class User < ActiveRecord::Base
  validates_presence_of(:email, :message => "should not be blank")
  validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :message => "is not valid"
  validates_uniqueness_of(:email, :message => "already exists", :case_sensitive => false)
  validates_presence_of(:password, :message => "should not be blank")
end
