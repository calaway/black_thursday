require_relative '../lib/file_extractor'
require_relative '../lib/merchant'

class MerchantRepository
  attr_reader :merchants

  def initialize(load_path, sales_engine_parent = nil)
    @sales_engine_parent = sales_engine_parent
    @merchants = {}
    populate(load_path)
  end

  def make_merchant(merchant_data)
    @merchants[merchant_data[:id].to_i] = Merchant.new(merchant_data, self)
  end

  def populate(load_path)
    if load_path.class == String && File.exist?(load_path)
      merchants_data = FileExtractor.extract_data(load_path)
      merchants_data.each do |merchant_data|
        make_merchant(merchant_data)
      end
    end
  end

  def all
    merchants.values
  end

  def find_by_id(merchant_id)
    merchants[merchant_id]
  end

  def find_by_name(merchant_name)
    merchants.values.find do |merchant|
      merchant.name.downcase == merchant_name.downcase
    end
  end

  def find_all_by_name(name_fragment)
    merchants.values.find_all do |merchant|
      merchant.name.downcase.include?(name_fragment.downcase)
    end
  end

  def find_items_by_merchant_id(merchant_id)
    @sales_engine_parent.find_items_by_merchant_id(merchant_id)
  end

  def find_invoices_by_merchant_id(merchant_id)
    @sales_engine_parent.find_invoices_by_merchant_id(merchant_id)
  end

  def find_customers_by_merchant_id(merchant_id)
    @sales_engine_parent.find_customers_by_merchant_id(merchant_id)
  end

  def inspect
    # "#<#{self.class} #{@merchants.size} rows>"
  end
end
