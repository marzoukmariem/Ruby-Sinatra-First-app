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
					 begin

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
				 Money.infinite_precision = false
				 Money.locale_backend = nil
				 Money.add_rate("USD","EUR",rate1)
				 Money.add_rate("EUR","USD",1/rate1)
				 Money.add_rate("USD","CHF",rate2)
				 puts '1 euro egale :'
				 puts 1/rate1
				 puts '$'
				 puts '1 dollar egale :'
				 puts 1/rate2
				 puts 'chf'
				 a = Float(params[:amount])
				 #eur_usd = Money.new(a, "EUR").exchange_to("USD")
				 # puts 'conversion eur_usd ='
				 # puts eur_usd
				 # puts 'conversion eur_chf ='
				 # usd_chf = Money.new(eur_usd, "USD").exchange_to("CHF")
				 # puts usd_chf
				 eur_usd = a / rate1
				 usd_chf= eur_usd * rate2
				 @convertion = Convertion.new(:amount => a,:result_usd => eur_usd.round(4),	:result_chf => usd_chf.round(4))
				 @convertion.save
				 erb :index
					 rescue
						 erb :error

					 end
			end



		get '/' do
			@convertion = Convertion.new(:amount => 0,:result_usd => 0,	:result_chf => 0)
			erb :index
		end



  # this method will redirect to operations view wich display all operations

	post '/Operations' do

	@operations = Convertion.all
if @operations.count == 0
	erb :nooperation
else
	erb :opertions
end
	end


end
