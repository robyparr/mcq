module ApplicationHelper
  def external_link_to(title, url, options = {})
    link_options = options.merge(
      target: '_blank',
      rel:    'noopener noreferrer'
    )

    link_to(url, link_options) do
      sanitize(title, tags: []) + ' <i class="fas fa-external-link-alt text-sm"></i>'.html_safe
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
end
