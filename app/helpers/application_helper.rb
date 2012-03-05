module ApplicationHelper

  def currency(amount)
    if amount
      css_class = 'currency'
      css_class << ' negative' if amount < 0
      content_tag(:span, number_to_currency(amount.abs), :class => css_class)
    else
      '<span class="updating">Updating...</span>'.html_safe
    end
  end
end
