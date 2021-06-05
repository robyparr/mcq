module ApplicationHelper
  def external_link_to(title, url, options = {})
    link_options = options.merge(
      target: '_blank',
      rel:    'noopener noreferrer'
    )

    content_fragments = [
      sanitize(title, tags: []),
      '<i class="small bi bi-box-arrow-right icon"></i>'
    ]
    content_fragments.reverse! if options[:icon_position] == :left

    link_to(url, link_options) do
      content_fragments.join(' ').html_safe
    end
  end

  def active_link_to(text = nil, url = nil, options = {}, &block)
    if block_given?
      options = url || {}
      url = text
      link_to url, active_link_to_options(url, options), &block
    else
      link_to text, url, active_link_to_options(url, options)
    end
  end

  private

  def active_link_to_options(url, options)
    active_subpage = current_or_subpage?(url, root_path: options.fetch(:root_path, false))
    active_extra_check = options.fetch(:active_extra, true)

    classes = options[:class] || ''
    classes += ' active' if active_subpage && active_extra_check

    options.merge(class: classes)
  end

  def current_or_subpage?(url, root_path: false)
    paramless_url = url_without_params(url)
    current_page_path.start_with?(paramless_url) || (root_path && root_path?)
  end

  def root_path?
    current_page_path == '/'
  end

  def current_page_path
    URI::parse(request.original_url).path
  end

  def url_without_params(url)
    URI::parse(url).path
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

  def integration_icon_class(integration_service)
    case integration_service
    when 'Pocket' then 'pocket'
    else ''
    end
  end

  def current_user_queues
    @current_user_queues ||= current_user.queues.order(:created_at).sort_by { _1.inbox? ? 0 : 1 }
  end

  def current_queue
    return unless params[:queue].present?

    @current_queue ||= current_user_queues.find { _1.id == params[:queue].to_i }
  end

  def turbo_stream_toast(message, type: :info)
    turbo_stream.append 'toast-container' do
      content_tag(:div, class: "#{type} toast", data: { controller: 'toast', action: 'click->toast#removeToast' }) do
        message
      end
    end
  end
end
