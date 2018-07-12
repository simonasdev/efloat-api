module ApplicationHelper

  def import_button text, path, format = :xlsx
    render partial: 'shared/import_button', locals: { path: path, format: format, text: text }
  end

  def render_flash name, message
    content_tag :div, class: "alert alert-#{ name.to_sym == :error ? "danger" : "success" } alert-dismissable", role: :alert do
      concat(content_tag(:button, class: 'close', type: :button, data: { dismiss: :alert }) do
        concat content_tag :span, '&times;'.html_safe, 'aria-hidden' => true
        concat content_tag :span, 'Close', class: 'sr-only', 'aria-hidden' => true
      end)
      concat message
    end
  end

  def paginate objects, options = {}
    options.reverse_merge!(theme: 'twitter-bootstrap-3')

    super(objects, options)
  end
end
