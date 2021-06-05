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
    select_options(
      MediaItem.consumption_difficulties,
      params[:difficulty],
      empty_value: 'Select a difficulty'
    )
  end

  def options_for_media_item_priority(priorities)
    select_options(
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

  def media_icon(media_item)
    case media_item.type
    when 'Article' then 'bi bi-file-text'
    when 'Video' then 'bi bi-film'
    end
  end

  def state_select_options
    selected_state = params[:state] || :not_complete
    available_options =
      [
        ['Not complete', :not_complete],
        ['Complete', :complete],
        ['Snoozed', :snoozed],
      ]

    select_options(available_options, selected_state)
  end

  def snooze_until_options
    now = Time.zone.today

    [
      ['Until', 'Tomorrow',   now + 1.day],
      ['Until', 'Next week',  now + 1.week],
      ['For',   'Two weeks',  now + 2.weeks],
      ['Until', 'Next month', now + 1.month],
      ['For',   'Two months', now + 2.months],
    ]
  end

  def snooze_until_menu_item(media_item, snooze_until:, prefix: nil, label:)
    snooze_url = snooze_media_item_url(media_item, snooze_until: snooze_until, queue: params[:queue])
    content_tag(:li) do
      testid = ['snooze', prefix, label].compact.map(&:downcase).join('-')
      link_to(snooze_url, class: 'menu-item', method: :post, data: { testid: testid }) do
        snooze_until_label(prefix, label) +
        content_tag(:span, class: 'text-muted ml-4') do
          if snooze_until
            "#{snooze_until.to_date} at 9 AM"
          else
            'Now'
          end
        end
      end
    end
  end

  def snooze_until_label(prefix = nil, label)
    content_tag(:span) do
      if prefix
        content_tag(:span, class: 'opacity-75 mr-1') do
          prefix
        end
      else
        ''.html_safe
      end +
      content_tag(:span, class: 'font-medium') do
        label
      end
    end
  end
end
