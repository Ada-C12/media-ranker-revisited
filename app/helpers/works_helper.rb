module WorksHelper
  def view_badge_adder(views)
    return unless views > -1
    return (
    '<span class="badge badge-secondary">'.html_safe + views.to_s + '</span>'.html_safe
    )
  end
end
