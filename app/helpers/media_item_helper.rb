module MediaItemHelper
  def consumption_difficulty_classes(difficulty)
    case difficulty
    when 'easy'   then 'text-green-600'
    when 'medium' then 'text-yellow-600'
    when 'hard'   then 'text-red-600'
    else ''
    end
  end

  def options_for_media_item_difficulty
    enum_for_select(
      MediaItem.consumption_difficulties,
      params[:difficulty],
      empty_value: 'Select a difficulty'
    )
  end

  def options_for_media_item_priority(priorities)
    enum_for_select(
      priorities,
      params[:priority],
      empty_value: 'Select a priority'
    )
  end

  def toggle_class_for_type(media_item, type)
    return 'toggled' if media_item.new_record? && type == 'Article'
    return 'toggled' if media_item.type == type

    ''
  end
end
