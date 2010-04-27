require "#{File.dirname(__FILE__)}/lib/arturaz/ruby_extensions.rb"

Array.send(:include, Arturaz::ArrayExtensions)
String.send(:include, Arturaz::StringExtensions)
Hash.send(:include, Arturaz::HashExtensions)

#String.send(:alias_method, :downcase_without_lithuanian_letters, :downcase)
#String.send(:alias_method, :downcase, :downcase_with_lithuanian_letters)
#String.send(:alias_method, :upcase_without_lithuanian_letters, :upcase)
#String.send(:alias_method, :upcase, :upcase_with_lithuanian_letters)
