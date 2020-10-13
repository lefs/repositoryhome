class Key < ActiveRecord::Base
  belongs_to :user

  attr_accessible :name, :body
    
  validates :user_id, presence: true
  validates :name, presence: true,
                   length: { maximum: 512 }
  validates :body, presence: true,
                   # Not sure what the maximum string length for a key can be.
                   # Need to check and update this accordingly.
                   length: { maximum: 4096 }

  # Remove line breaks, carriage return.
  before_validation { self.body = self.body.to_s.strip.gsub(/(\r|\n)*/m, '') }
end
