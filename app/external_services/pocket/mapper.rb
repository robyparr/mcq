module Pocket
  module Mapper
    class << self
      def map_items(pocket_items)
        pocket_items.map(&method(:map_item))
      end

      def map_item(pocket_item)
        {
          id: pocket_item[:item_id],
          title: pocket_item[:given_title] || pocket_item[:resolved_title],
          url: pocket_item[:given_url],
          time_to_read: pocket_item[:time_to_read],
        }
      end
    end
  end
end
