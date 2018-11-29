class Admin < ApplicationRecord

  #  Devise.
  #
  devise :database_authenticatable, :lockable, :recoverable, :rememberable, :trackable, :validatable

end