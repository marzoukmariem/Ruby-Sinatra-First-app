require 'rubygems'
require 'sinatra'
require 'haml'
require 'money'
require 'money/bank/open_exchange_rates_bank'
require 'money/bank/currencylayer_bank'
require 'money-rails'
class ApplicationController < Sinatra::Base
	# This configuration part will inform the app where to search for the views and from where it will serve the static files


  	configure do
    	set :views, "app/views"
    	set :public_dir, "public"
  	end

  	get '/' do

			bank = Money::Bank::CurrencylayerBank.new()
			bank.secure_connection = false
			bank.access_key = 'f06206a6038d9c8eaed8cf8aa3d05de9'
			puts bank.source_url
			responses = bank.export_rates(:json)
			puts 'rates'
			puts	bank.super_get_rate("USD","EUR")
			puts responses
			puts Money.default_bank.get_rate('USD', 'CHF','EUR')
			Money.infinite_precision = true
			Money.locale_backend = nil
			Money.add_rate("USD","EUR",0.904871)
			Money.add_rate("EUR","USD",1.10)
			puts Money.new(1, "USD").exchange_to("EUR").to_f
			puts Money.new(100, "EUR").as_us_dollar
			puts Money.from_amount(1,"USD",bank)
			puts Money.new(100,"USD",bank)



			#mclb = Money::Bank::CurrencylayerBank.new()
			#	mclb.secure_connection = false
			#Money::Currency.new("EUR")
			#	Money.default_bank = mclb
			#mclb.access_key = 'f06206a6038d9c8eaed8cf8aa3d05de9'
			#Money.new(1000, 'USD').exchange_to('EUR').to_f
			#Money.default_currency = Money::Currency.new("EUR")
			#mclb.source = 'EUR'
			#curr1 = Money.from_amount(2, "USD").amount.to_f

			#	puts curr1
			#puts mclb.source_url
			erb :index
  	end
end
