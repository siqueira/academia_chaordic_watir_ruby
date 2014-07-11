require 'watir-webdriver'
require 'test-unit'

# TEST SUITE
class SaraivaCart < Test::Unit::TestCase

	class << self
		def startup
			@@browser = Watir::Browser.start 'saraiva.com.br'
		end

		def shutdown
			@@browser.close
		end
	end


	# HELPERS
	def select_a_product
		@@browser.div(:class => 'product').link.click
		puts 'Product title: ' << @@browser.title
	end

	def click_buy_button
		@@browser.link(:class => 'botaoComprar').click
	end

	def set_zip_code zip_code
		@@browser.text_field(:name => 'CEP').set zip_code	
	end

	def click_shipping_calc_button
		@@browser.button(:name => 'btnCalcFrete').click
	end

	def product_price_from_site
		preco = @@browser.td(:class => 'itens_valor').text
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

	# TEST CASES
	def test_check_shipping_cost
		select_a_product
		click_buy_button
		set_zip_code '88062000'
		click_shipping_calc_button
		price = product_price_from_site
		
		assert_not_equal price, 0
		puts 'Product price: ' + product_price_from_site
		puts 'Shiping cost: ' + shipping_price
		puts 'Sum: ' << (product_price_from_site + shipping_price)
	end
end