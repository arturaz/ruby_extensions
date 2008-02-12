require "#{File.dirname(__FILE__)}/lib/arturaz/array_extensions.rb"
require "#{File.dirname(__FILE__)}/lib/arturaz/string_extensions.rb"

Array.send(:include, Arturaz::ArrayExtensions)
String.send(:include, Arturaz::StringExtensions)

#String.send(:alias_method, :downcase_without_lithuanian_letters, :downcase)
#String.send(:alias_method, :downcase, :downcase_with_lithuanian_letters)
#String.send(:alias_method, :upcase_without_lithuanian_letters, :upcase)
#String.send(:alias_method, :upcase, :upcase_with_lithuanian_letters)
