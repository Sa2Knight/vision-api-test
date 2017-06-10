require 'rack/protection'
require './app/app'

run App.new
