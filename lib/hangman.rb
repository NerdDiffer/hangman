require 'yaml'

['save', 'load', 'show', 'game'].each do |file|
  require_relative file
end
