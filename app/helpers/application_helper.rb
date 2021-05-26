module ApplicationHelper
  def format_balance(balance)
    balance['amount'] + balance['denom']
  end

  def deployment_uri(deployment)
    if uri = deployment.uris.first
      link_to uri.host, uri.to_s, target: :blank, class: 'small'
    elsif port = deployment.ports.first
      content_tag(:span, [port[:host], port[:externalPort]].join(':'), class: 'small')
    end
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
