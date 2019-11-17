require 'rubygems'
require 'data_mapper'
require 'sinatra'
require 'haml'
require 'money'
require 'money/bank/open_exchange_rates_bank'
require 'money/bank/currencylayer_bank'
require 'money-rails'
require 'json'
require 'net/http'
require './app/models/Convertion.rb'
require'form'

class ApplicationController < Sinatra::Base
	# This configuration part will inform the app where to search for the views and from where it will serve the static files
	# include SimpleForm::ActionViewExtensions::FormHelper

  	configure do
    	set :views, "app/views"
    	set :public_dir, "public"
  	end


# this method will  convert the amount enter  to USD end CHF using Currencylayer api and insert the values in the database
 		     post '/add' do
				 bank = Money::Bank::CurrencylayerBank.new()
				 bank.secure_connection = false
				 bank.access_key = 'f06206a6038d9c8eaed8cf8aa3d05de9'
				 puts bank.source_url
				 uri = URI(bank.source_url)
				 response = Net::HTTP.get(uri)
				 response_obj = JSON.parse(response)
				 puts  response_obj
				 rate1 = response_obj['quotes']['USDEUR']
				 rate2 = response_obj['quotes']['USDCHF']
				 Money.infinite_precision = true
				 Money.locale_backend = nil
				 Money.add_rate("USD","EUR",rate1)
				 Money.add_rate("EUR","USD",1/rate1)
				 Money.add_rate("USD","CHF",rate2)
				 Money.add_rate("CHF","USD",1/rate2)
				 a = params[:amount]
				 eur_usd = Money.new(a*100, "EUR").exchange_to("USD").to_f
				 puts 'conversion eur_usd ='
				 puts eur_usd
				 puts 'conversion eur_chf ='
				 usd_chf = Money.new(eur_usd*100, "USD").exchange_to("CHF").to_f
				 puts usd_chf
				 @convertion = Convertion.new(:amount => a,:result_usd => eur_usd.round(5),	:result_chf => usd_chf.round(5))
				 @convertion.save
				 erb :index
			end



		get '/' do
			@convertion = Convertion.new(:amount => 0,:result_usd => 0,	:result_chf => 0)
			erb :index
		end



  # this method will redirect to operations view wich display all operations

	post '/Operations' do

	@operations = Convertion.all
	puts @operations
	erb :opertions
	end


end
