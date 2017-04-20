module Spree
  module OrderContentsWithTracker

    # Override: since order's line_items were overridden
    def update_cart(params)
      if order.update_attributes(params)
        order.line_items.select(&:quantity_previously_changed?).each do |line_item|
          Spree::Cart::Event::Tracker.new(
            actor: order, target: line_item, total: order.total, variant_id: line_item.variant_id
          ).track
        end
        # line_items which have 0 quantity will be lost and couldn't be tracked
        # so tracking is done before the execution of next statement
        order.line_items = order.line_items.select { |li| li.quantity > 0 }
        reload_totals
        PromotionHandler::Cart.new(order).activate
        order.ensure_updated_shipments
        reload_totals
        true
      else
        false
      end
    end

    private

    # Override: Add tracking entry after a line_item is added or removed
    def after_add_or_remove(line_item, options = {})
      line_item = super
      Spree::Cart::Event::Tracker.new(
        actor: order, target: line_item, total: order.total, variant_id: line_item.variant_id
      ).track
      line_item
    end
  end
end

Spree::OrderContents.send(:prepend, Spree::OrderContentsWithTracker)
