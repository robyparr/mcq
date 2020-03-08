module Pocket
  module Items
    def items
      body = default_params.merge(
        contentType: 'article',
        state: 'unread',
        count: 50,
        detailType: 'simple',
      )
      body.merge!(count: 1, tag: 'mcq-test') if Rails.env.development?

      response = post('/get', body: body)

      if response[:list].present?
        Pocket::Mapper.map_items response[:list].values
      else
        []
      end
    end

    def archive_and_tag_items(item_ids, tag)
      body = %i[tags_add archive].flat_map do |action|
        item_ids.map do |item_id|
          action_attrs = {
            action:  action.to_s,
            item_id: item_id.to_i,
          }
          action_attrs[:tags] = tag if action == :tags_add

          action_attrs
        end
      end

      post '/send', body: default_params.merge(actions: body.to_json).to_param
    end
  end
end
