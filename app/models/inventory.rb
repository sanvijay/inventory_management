# frozen_string_literal: true

class Inventory < ApplicationRecord
  include AASM
  has_paper_trail

  enum state: {
    "opened" => "opened",
    "verified" =>  "verified"
  }

  aasm column: :state, enum: true do
    state :opened, initial: true
    state :verified

    event :verify do |args|
      before do |user_id|
        self.verified_at = Time.zone.now
        self.verified_by_id = user_id
      end

      transitions from: :opened, to: :verified
    end

    event :unverify do |args|
      before do |aaa|
        self.verified_at = nil
        self.verified_by_id = aaa
      end

      transitions from: :verified, to: :opened
    end
  end

  belongs_to :item
  belongs_to :department
  belongs_to :verified_by, class_name: "User", optional: true
  belongs_to :created_by, class_name: "User", optional: true

  validates :requested_quantity, presence: true
  validates :created_by, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["department", "item", "verified_by", "versions", "created_at", "department_id", "id", "item_id", "item_version", "requested_quantity", "state", "updated_at", "verified_at", "verified_by_id"]
  end
end
