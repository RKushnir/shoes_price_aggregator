module NotifierHelper
  def sorted_price_changes(price_changes)
    division_order = %w[male female boys girls access care]
    price_changes.sort_by {|pc| division_order.index(pc[:product].division) }
  end
end
