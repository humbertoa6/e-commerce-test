# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :user
end
