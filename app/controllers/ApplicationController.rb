require 'rubygems'
require 'sinatra'

require 'haml'
require 'money'
require 'money/bank/open_exchange_rates_bank'
require 'money/bank/currencylayer_bank'
class ApplicationController < Sinatra::Base
	# This configuration part will inform the app where to search for the views and from where it will serve the static files


  	configure do
    	set :views, "app/views"
    	set :public_dir, "public"
  	end

  	get '/' do

			@name = 'maryem'
			mclb = Money::Bank::CurrencylayerBank.new
			mclb.access_key = 'f06206a6038d9c8eaed8cf8aa3d05de9'
			mclb.ttl_in_seconds = 86400
			mclb.secure_connection = false
			Money.default_currency = Money::Currency.new("EUR")

			curr1 = Money.from_amount(2, "USD").amount.to_f

			puts 'second amount'
			puts curr1
			puts mclb.source_url
			erb :index
  	end
end
