module Spree
  class CartEvent < Spree::Base

    belongs_to :actor, polymorphic: true
    belongs_to :target, polymorphic: true
    belongs_to :variant
    has_one :product, through: :variant

    validates :activity,
              :actor,
              :quantity,
              :target,
              :total,
              :variant, presence: true

    scope :added,   -> { where(activity: 'add')    }
    scope :removed, -> { where(activity: 'remove') }
    scope :updated, -> { where(activity: 'update') }
  end
end
