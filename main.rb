require 'sinatra/base'
require_relative 'helpers/application_helper'
Dir['./lib/*.rb'].each { |f| require f }

class Main < Sinatra::Base
  helpers ApplicationHelper

  get '/' do
    erb :index
  end
end
