require './state.rb'
require './country.rb'
require './ui.rb'
require './controller.rb'
require 'JSON'
require './json_importer.rb'

vote = Controller.new
vote.run
