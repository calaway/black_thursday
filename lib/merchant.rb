class Merchant
  attr_reader :id,
              :name,
              :created_at,
              :updated_at

  def initialize(merchant, merchant_repository_parent = nil)
    @merchant_repository_parent = merchant_repository_parent
    @id = merchant[:id].to_i
    @name = merchant[:name]
    @created_at = Time.parse(merchant[:created_at])
    @updated_at = Time.parse(merchant[:updated_at])
  end

  def items
    @merchant_repository_parent.find_items_by_merchant_id(id)
  end

  def invoices
    @merchant_repository_parent.find_invoices_by_merchant_id(id)
  end

  def customers
    @merchant_repository_parent.find_customers_by_merchant_id(id)
  end
end
