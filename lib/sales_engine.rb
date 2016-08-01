require_relative '../lib/merchant_repository'
require_relative '../lib/item_repository'
require_relative '../lib/invoice_repository'
require_relative '../lib/customer_repository'

class SalesEngine
  attr_reader :merchants,
              :items,
              :invoices
              # :invoice_items,
              # :customers

  def initialize(load_paths)
    @merchants = MerchantRepository.new(load_paths[:merchants], self)
    @items     = ItemRepository.new(load_paths[:items], self)
    @invoices  = InvoiceRepository.new(load_paths[:invoices], self)
    # @invoice_items = InvoiceItemsRepository(load_paths[:items], self)
    # @customers = CustomerRepository.new(load_paths[:customers], self)
  end

  def self.from_csv(load_paths)
    self.new(load_paths)
  end

  def find_merchant_by_item_id(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def find_merchant_by_invoice_id(merchant_id)
    merchants.find_by_id(merchant_id)
  end

  def find_items_by_merchant_id(merchant_id)
    items.find_all_by_merchant_id(merchant_id)
  end

  def find_invoices_by_merchant_id(merchant_id)
    invoices.find_all_by_merchant_id(merchant_id)
  end

end





# temp_item.rb
#require 'minitest/mock'
#mock_se = Minitest::Mock.new
#mock_se.expect(:find_merchant_by_id, "merchant", ["merchant_id"])
