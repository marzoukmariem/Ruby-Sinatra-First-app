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
			@amount=20
			@name = 'maryem'
			puts '20'
			mclb = Money::Bank::CurrencylayerBank.new
			mclb.access_key = 'f06206a6038d9c8eaed8cf8aa3d05de9'
			mclb.ttl_in_seconds = 86400
			mclb.secure_connection = true
			Money.default_bank = mclb
			money = Money.new(1_00, "USD")
			Money.new(1000, 'USD').exchange_to('EUR').format
			erb :index
  	end
end
