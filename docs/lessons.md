# Lessons From Dev

## Turbo and Downloads

* For a controller action that downloads a file, such as an xlsx file, you need to turn off turbo with this configuration on the link used to activate the download:

```html
<a class="btn btn-secondary float-end me-2" role="button" data-turbo="false" data-turbo-method="get" href="/admin/links/export_xlsx">
  <i class="bi-file-spreadsheet"></i>
  Download
</a>
```

## Turbo and UJS

* Rails used ujs for x
* Now, Rails uses hotwire/turbo to solve the same problem
* In Rails 8+ buttons and links using methods other than GET or POST need to be configured as such:

```html
<a class="btn btn-secondary float-end me-2" role="button" data-turbo="true" data-turbo-method="get" href="/admin/links/export_xlsx">
  <i class="bi-file-spreadsheet"></i>
  Download
</a>
```

## TomSelect and Capybara

* TomSelect.js manipulates the html structure of a select field to a degree that capybara select/find doesn't natively work
* You need to create a TomSelectHelper method that instructs capybara specifically how to find and click on an option

```rb
# spec/support/tom_select_helper.rb

module TomSelectHelper
  def fill_in_tom_select_field(input_selector:, text_value:)
    # Find the TomSelect wrapper
    wrapper = find("#{input_selector} + .ts-wrapper")
    wrapper.click

    # Wait for dropdown and select option
    within('.ts-dropdown-content') do
      find('.option', text: text_value, wait: 5, exact_text: true).click
    end
  end
end
```

```rb
# spec/rails_helper.rb

RSpec.configure do |config|
  config.include TomSelectHelper, type: :feature
end
```

```rb
# spec/features/admin_system_permission_spec.rb

fill_in_tom_select_field_outset(
  input_selector: '#system_permission_operation',
  text_value: operation.upcase
)
```
