require 'bcrypt'

# Identification module setup and validate password
module Identification
  extend ActiveSupport::Concern
  include BCrypt

  # get password
  def password
    @password ||= Password.new(password_hash) unless password_hash.blank?
  end

  # set password
  def password=(new_password)
    if new_password.blank?
      @password = ''
      self.password_hash = ''
    else
      @password = Password.create(new_password)
      self.password_hash = @password
    end
  end

  # validates the presence of password for an authenticatable
  def password_presence
    add_error(:password, 'errors.messages.blank') if password.blank?
  end

  def generate_temporary_password
    temporary_password = SecureRandom.hex(3).upcase
    self.password = temporary_password
    save
    temporary_password
  end

  def authenticate(password)
    password?(password) ? true : add_error!(:Login, 'exceptions.auth.invalid')
  end

  def password?(password)
    self.password == password
  end

  # setup a new password and save
  def change_password(params, confirmation = false)
    authenticate(params[:old_password]) if confirmation
    self.password = params[:password]
    self.class.raise_model(:password, 'errors.messages.blank') if password.blank?
    save
  end
end
