module ApplicationHelper
  include Pagy::Frontend

  def file_name_with_timestamp(file_name:, file_extension:)
    "#{file_name}_#{DateTime.now.strftime('%Y-%m-%d_%H-%M-%S')}.#{file_extension}"
  end

  def default_date_format(date_value)
    if date_value.respond_to?(:strftime)
      date_value.strftime('%b %e, %Y')
    else
      date_value
    end
  end

  def selector_date_format(date_value)
    if date_value.respond_to?(:strftime)
      date_value.strftime('%Y-%m-%d')
    else
      date_value
    end
  end

  def external_link_to(name, url, options = {})
    default_options = { target: '_blank', rel: 'noopener noreferrer' }

    link_to(name, url, default_options.merge(options))
  end

  def format_rnk(val)
    val.nil? || val.negative? ? 0 : val.round
  end

  def format_rating(pres, proj)
    present = pres.nil? || pres.negative? ? 0 : pres.round
    projected = proj.nil? || proj.negative? ? 0 : proj.round
    "#{present} / #{projected}"
  end

  def format_stat(val, type)
    return '0' if val.nil? || val.negative?

    case type
    when :hundreths
      number_with_precision(val, precision: 3).sub(/^0/, '')
    when :integer
      val.to_i.to_s
    when :percent
      "#{number_with_precision(val, precision: 0)}%"
    else
      val.to_s
    end
  end

  def years_until_today(date)
    return 0 if date.nil?
    return 0 unless date.is_a?(Date)
    return 0 if date > Date.today

    today = Date.today
    years_difference = today.year - date.year
    years_difference -= 1 if today < date + years_difference.years
    years_difference.to_i.to_s
  end
end
