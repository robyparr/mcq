if Rails.env.development?
  Bullet.enable = true
  Bullet.add_footer = true
  Bullet.rails_logger = true

  Bullet.add_whitelist(
    type:        :unused_eager_loading,
    class_name:  'MediaQueue',
    association: :active_media_items
  )

  Bullet.add_whitelist(
    type:        :counter_cache,
    class_name:  'MediaQueue',
    association: :active_media_items
  )
end
