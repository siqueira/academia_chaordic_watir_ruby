require 'watir-webdriver'
require 'test-unit'

# TEST SUITE
class TestSuiteSaraivaProductCostCalculation < Test::Unit::TestCase

	b = Watir::Browser.start 'saraiva.com.br'
	b.div(:class => 'product').link.click
	b.link(:class => 'botaoComprar').click
	b.text_field(:name => 'CEP').set '89010020'
	b.button(:name => 'btnCalcFrete').click

	preco = b.td(:class => 'itens_valor').text
	preco.gsub!("R$ ","")
	preco.gsub!("  ","")
	preco.gsub!(",",".")
	preco.to_f

	puts 'preço do produto: ' + preco

	puts 'preço do frete: ' + b.td(:class => 'frete_valor').text

end