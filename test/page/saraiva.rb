require 'page-object'

class Saraiva
	include PageObject

	page_url 'saraiva.com.br'

	# HOME PAGE
	div :product, :class => 'product'

	# PRODUCT PAGE
	link :buy_link, :class => 'botaoComprar'

	# CART PAGE
	text_field :cep, :name => 'CEP'
	button :btn_shipping_calc, :name => 'btnCalcFrete'
	td :item_value, :class => 'itens_valor'
end