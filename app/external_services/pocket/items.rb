module Pocket
  module Items
    def items
      response = post(
        '/get',
        body: default_params.merge({ 'contentType' => 'article' })
      )

      response[:list].values.map(&:symbolize_keys)
    end
  end
end
