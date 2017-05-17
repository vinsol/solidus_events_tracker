module Spree
  class PageEvent < Spree::Base
    ACTIVITIES = { view: :view, search: :search, filter: :filter, index: :index }

    belongs_to :actor, polymorphic: true
    belongs_to :target, polymorphic: true

    validates :activity,
              :session_id, presence: true

    scope :viewed, -> { where(activity: :view) }
    scope :product, -> { where(target_type: 'Spree::Product') }
  end
end
