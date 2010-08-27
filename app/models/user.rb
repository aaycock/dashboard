require 'digest/sha1'

class User < ActiveRecord::Base

  belongs_to :account

  validates_presence_of :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid address"

  attr_accessor :password_confirmation
  #validates_confirmation_of :password

  #validate :password_non_blank

  def self.authenticate(email, password)
    user = self.find_by_email(email) # TODO: not sure about this method
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end

  #password is a virtual attribute
  def password
    @password
  end

  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def send_new_password
    new_pass = set_random_password
    Emailer.deliver_forgot_password(self.email, self.email, new_pass)
  end

  def set_random_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    new_pass
  end

  private

  def password_non_blank
    errors.add(:password, "Missing Password") if hashed_password.blank?
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt
    Digest::SHA1.hexdigest(string_to_hash)
  end

   def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end
end
