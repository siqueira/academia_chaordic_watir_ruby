require 'watir-webdriver'
require 'test-unit'
# Colocar gem 'page-object' no Gemfile
require 'page-object'
require_relative './page/saraiva.rb'

# TEST SUITE
class TestSaraivaProductShippingCost < Test::Unit::TestCase
	include PageObject

	class << self
		def startup
			@@browser = Watir::Browser.start 'saraiva.com.br'
			@@saraiva = Saraiva.new
		end

		def shutdown
			@@browser.close
		end
	end


	# HELPERS
	def select_a_product
		@@saraiva.product.link.click
		puts 'Product title: ' << @@browser.title
	end

	def click_buy_button
		@@saraiva.buy_link
	end

	def set_zip_code zip_code
		@@saraiva.cep = zip_code	
	end

	def click_shipping_calc_button
		@@saraiva.btn_shipping_calc
	end

	def product_price_from_site
		preco = @@saraiva.item_value
		remove_money_characters_and_return_float preco
	end

	def shipping_price
		@@browser.tds(:class => 'frete_valor').each do |td|
			@shipping_price = td.text if td.text['R$'] != nil
			end
		remove_money_characters_and_return_float @shipping_price
	end

	def remove_money_characters_and_return_float price
		price.gsub!("R$ ","").gsub!("  ","").gsub!(",",".").to_f
	end

	def total_order_price_from_site
		@@browser.tds(:class => 'quantidade').each do |td|
			@total_price = td.text if td.text['R$'] != nil
			end
		remove_money_characters_and_return_float @total_price
	end

	# TEST CASES
	def test_check_shipping_cost
		select_a_product
		click_buy_button
		set_zip_code '88062000'
		click_shipping_calc_button
		price = product_price_from_site
		
		assert_not_equal price, 0
		
		puts 'Product price: ' + product_price_from_site.to_s
		puts 'Shiping cost: ' + shipping_price.to_s
		
		total_price = product_price_from_site + shipping_price
		puts 'Sum: ' << total_price.to_s
		
		assert_equal total_price.round(1), total_order_price_from_site 
	end
end