module TomSelectHelper
  def fill_in_tom_select_field(input_selector:, ancestor_selector:, text_value:)
    input = find(input_selector)
    ancestor = input.ancestor(ancestor_selector)
    ancestor.click
    find('option', text: text_value, exact_text: true).click
  end

  def fill_in_tom_select_field_not_working(input_selector:, text_value:)
    # Find the TomSelect wrapper
    wrapper = find("#{input_selector} + .ts-wrapper")
    wrapper.click

    # Wait for dropdown and select option
    within('.ts-dropdown-content') do
      find('.option', text: text_value, wait: 5, exact_text: true).click
    end
  end
end
