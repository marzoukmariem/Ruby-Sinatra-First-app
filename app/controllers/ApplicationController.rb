require 'rubygems'
require 'sinatra'
require 'money/bank/currencylayer_bank'
require 'logger'
class ApplicationController < Sinatra::Base
	# This configuration part will inform the app where to search for the views and from where it will serve the static files
	  logger.info "user did something interesting!"
		puts'hello'
		mclb = Money::Bank::CurrencylayerBank.new
		mclb.access_key = 'f06206a6038d9c8eaed8cf8aa3d05de9'
		mclb.update_rates
		mclb.source = 'EUR'
		mclb.ttl_in_seconds = 86400
		mclb.secure_connection = true
		let money =Money.new(1000, 'USD').exchange_to('EUR')
		puts money
		let maryem='m'
  	configure do
    	set :views, "app/views"
    	set :public_dir, "public"
  	end

  	get '/' do
   		erb :index
  	end




end
