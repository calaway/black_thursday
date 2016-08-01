class SalesAnalyst
  attr_reader :sales_engine

  def initialize(sales_engine)
    @sales_engine = sales_engine
    @all_merchants = @sales_engine.merchants.merchants
    @all_items = @sales_engine.items.items
    @all_invoices = @sales_engine.invoices.invoices
  end

  def average_items_per_merchant
    (@all_items.count.to_f / @all_merchants.count).round(2)
  end

  def items_per_merchant
    @all_merchants.keys.map do |merchant_id|
      sales_engine.items.find_all_by_merchant_id(merchant_id).count
    end
  end

  def sample_standard_deviation(sample, average)
    differences_squared = sample.map do |number|
      (number - average) ** 2
    end
    Math.sqrt( differences_squared.reduce(:+) /
    (sample.count - 1).to_f ).round(2)
  end

  def average_items_per_merchant_standard_deviation
    sample_standard_deviation(items_per_merchant, average_items_per_merchant)
  end

  def coefficient_of_variation(average, standard_deviation, coefficient)
    average + coefficient * standard_deviation
  end

  def merchants_with_high_item_count
    cov = coefficient_of_variation(average_items_per_merchant,
      average_items_per_merchant_standard_deviation, 1)
    @all_merchants.values.find_all do |merchant|
      sales_engine.items.find_all_by_merchant_id(merchant.id).count > cov
    end
  end

  def average_item_price_for_merchant(merchant_id)
    items = sales_engine.items.find_all_by_merchant_id(merchant_id)
    items.inject(0) do |sum, item|
      sum += item.unit_price / items.count.to_f
    end.round(2)
  end

  def average_average_price_per_merchant
    total_merchants = @all_merchants.count
    @all_merchants.keys.inject(0) do |sum, merchant_id|
      sum += average_item_price_for_merchant(merchant_id) / total_merchants.to_f
    end.round(2)
  end

  def average_item_price
    total_items = @all_items.count
    @all_items.values.inject(0) do |sum, item|
      sum += item.unit_price / total_items.to_f
    end.round(2)
  end

  def item_price_standard_deviation
    item_prices = @all_items.values.map do |item|
      item.unit_price
    end
    sample_standard_deviation(item_prices, average_item_price)
  end

  def golden_items
    cov = coefficient_of_variation(average_item_price,
      item_price_standard_deviation, 2)
    @all_items.values.find_all do |item|
      item.unit_price > cov
    end
  end

  def average_invoices_per_merchant
    (@all_invoices.count.to_f / @all_merchants.count).round(2)
  end

  def invoices_per_merchant
    @all_merchants.keys.map do |merchant_id|
      sales_engine.invoices.find_all_by_merchant_id(merchant_id).count
    end
  end

  def average_invoices_per_merchant_standard_deviation
    sample_standard_deviation(invoices_per_merchant, average_invoices_per_merchant)
  end

  def top_merchants_by_invoice_count
    cov = coefficient_of_variation(average_invoices_per_merchant,
      average_invoices_per_merchant_standard_deviation, 2)
    @all_merchants.values.find_all do |merchant|
      sales_engine.invoices.find_all_by_merchant_id(merchant.id).count > cov
    end
  end

  def bottom_merchants_by_invoice_count
    cov = coefficient_of_variation(average_invoices_per_merchant,
      average_invoices_per_merchant_standard_deviation, -2)
    @all_merchants.values.find_all do |merchant|
      sales_engine.invoices.find_all_by_merchant_id(merchant.id).count < cov
    end
  end

  def invoices_per_day
    @all_invoices.values.each_with_object(Hash.new(0)) do |invoice, per_day|
      per_day[invoice.created_at.strftime('%A')] += 1
    end
  end

  def average_invoices_per_day
    (@all_invoices.count.to_f / 7 ).round(2)
  end

  def invoices_per_day_standard_deviation
    sample_standard_deviation(invoices_per_day.values, average_invoices_per_day)
  end

  def top_days_by_invoice_count
    cov = coefficient_of_variation(average_invoices_per_day,
      invoices_per_day_standard_deviation, 1)
    invoices_per_day.select do |day, quantity|
      quantity > cov
    end.keys
  end

  def invoices_by_status
    @all_invoices.values.each_with_object(Hash.new(0)) do |invoice, statuses|
      statuses[invoice.status] += 1
    end
  end

  def invoice_status(status)
    ( 100 * invoices_by_status[status] / @all_invoices.count.to_f ).round(2)
  end
end
