module ApplicationHelper
  def format_balance(balance)
    balance['amount'] + balance['denom']
  end
end
