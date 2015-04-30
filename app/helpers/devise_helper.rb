module DeviseHelper
  def devise_error_messages!
    return '' if resource.errors.empty?

    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
    html = <<-HTML
    <div id="error_explanation">
        <div class="alert alert-danger">
        The form contains #{pluralize(resource.errors.count, "error")}.
        <button type="button" class="close" data-dismiss="alert">
            <span aria-hidden="true">&times;</span>
            <span class="sr-only">Close</span>
        </button>
        </div>
        #{messages}
    </div>
    HTML

    html.html_safe
  end
end
