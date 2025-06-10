class Customer < ApplicationRecord
  validates :name, :phone, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, allow_blank: true
  validates :phone, format: { with: /\A\+?\d{10,15}\z/ }
  validates :email, :phone, uniqueness: true
end
