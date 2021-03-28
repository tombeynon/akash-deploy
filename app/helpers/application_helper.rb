module ApplicationHelper
  def format_balance(balance)
    balance['amount'] + balance['denom']
  end

  def active_class(class_string, active, active_class: 'active')
    active ? "#{class_string} #{active_class}" : class_string
  end

  def flash_class(level)
    case level&.to_sym
    when :notice then 'alert alert-info'
    when :success then 'alert alert-success'
    when :error then 'alert alert-danger'
    when :alert then 'alert alert-danger'
    end
  end
end
