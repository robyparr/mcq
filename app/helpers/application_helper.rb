module ApplicationHelper
  def external_link_to(title, url, options = {})
    link_options = options.merge(
      target: '_blank',
      rel:    'noopener noreferrer'
    )

    content_fragments = [
      sanitize(title, tags: []),
      '<i data-feather="external-link" class="inline w-4 h-4"></i>'
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
    classes += ' active' if current_or_subpage?(url, options)

    options.merge(class: classes)
  end

  def current_or_subpage?(url, root_path: false)
    current_page_path.start_with?(url) || (root_path && root_path?)
  end

  def root_path?
    current_page_path == '/'
  end

  def current_page_path
    URI::parse(request.original_url).path
  end

  def select_options(options, selected_key = nil, empty_value: nil)
    select_options = []
    select_options.push([empty_value, nil]) if empty_value.present?

    value_options =
      options.map do |option|
        if option.is_a?(Array)
          key, value = option
          [key.capitalize, value]
        else
          [option.capitalize, option]
        end
      end

    select_options.concat value_options

    options_for_select(select_options, selected_key)
  end

  def within_path?(path)
    request.path.start_with?(path)
  end

  def integration_icon_class(integration_service)
    case integration_service
    when 'Pocket' then 'pocket'
    else ''
    end
  end
end
