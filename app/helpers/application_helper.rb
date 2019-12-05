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
end
