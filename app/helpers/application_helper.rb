module ApplicationHelper
  def external_link_to(title, url, options = {})
    link_options = options.merge(
      target: '_blank',
      rel:    'noopener noreferrer'
    )

    content_fragments = [
      sanitize(title, tags: []),
      '<i class="fas fa-external-link-alt text-sm"></i>'
    ]
    content_fragments.reverse! if options[:icon_position] == :left

    link_to(url, link_options) do
      content_fragments.join(' ').html_safe
    end
  end

  def active_link_to(text = nil, url = nil, options = {}, &block)
    if block_given?
      url = text
      link_to url, active_link_to_options(url, options), &block
    else
      link_to text, url, active_link_to_options(url, options)
    end
  end

  private

  def active_link_to_options(url, options)
    classes = options[:class] || ''
    classes += ' active' if current_or_subpage?(url)

    options.merge(class: classes)
  end

  def current_or_subpage?(url)
    current_page_path = URI::parse(request.original_url).path
    current_page_path.start_with?(url)
  end

  def enum_for_select(enum_items, selected = nil, empty_value: '')
    options = [[empty_value, nil]]
    options.concat enum_items.map { |key, value| [key.capitalize, value] }

    options_for_select(options, selected)
  end

  def not_within_path(path, &block)
    return if request.path.start_with?(path)

    block.call
  end

  def integration_icon_class(integration_service)
    case integration_service
    when 'Pocket' then 'fab fa-get-pocket'
    else ''
    end
  end
end
