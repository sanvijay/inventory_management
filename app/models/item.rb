class Item < ApplicationRecord
  has_paper_trail

  validates :name, presence: true
  validates :reference_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true
  validates :image_url, format: URI::DEFAULT_PARSER.make_regexp(%w[http https]), allow_blank: true

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "model_number", "name", "reference_url", "updated_at"]
  end
end
