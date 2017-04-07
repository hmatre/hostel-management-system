class Subscription < ApplicationRecord
	belongs_to :User
	has_one :Transaction
end
