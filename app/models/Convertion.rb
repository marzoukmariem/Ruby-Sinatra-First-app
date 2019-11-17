require 'bundler/setup'
require 'rubygems'
require 'data_mapper'
class Convertion
  include DataMapper::Resource

  property :id,         Serial    # An auto-increment integer key
  property :amount,     Float
  property :result_usd, Float
  property :result_chf, Float
end
DataMapper.setup(:default, 'postgres://maryemtest:admin@localhost/test')
DataMapper.finalize
DataMapper.auto_upgrade!