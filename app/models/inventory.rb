class Inventory < ApplicationRecord
  include AASM
  has_paper_trail

  enum state: {
    'created' => 'created',
    'verified' =>  'verified'
  }

  aasm column: :state, enum: true do
    state :created, initial: true
    state :verified

    event :verify do |args|
      before do |user_id|
        self.verified_at = Time.zone.now
        self.verified_by_id = user_id
      end

      transitions from: :created, to: :verified 
    end
  end

  belongs_to :item
  belongs_to :department
  belongs_to :verified_by, class_name: 'User', optional: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "department_id", "id", "item_id", "item_version", "requested_quantity", "state", "updated_at", "verified_at", "verified_by_id"]
  end
end
