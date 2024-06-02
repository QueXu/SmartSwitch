class Device < ApplicationRecord
  belongs_to :user

  validates :name, presence: true
  validates :mac_address, presence: true, uniqueness: true

  enum state: { off: 'off', on: 'on' }
end
