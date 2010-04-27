# Ensure that libs are loaded only one time per spec-run.
if $SPEC_INITIALIZED.nil?
  ENV['environment'] = 'test'
  require 'rubygems'
  require 'activesupport'
  require 'spec'
  require File.dirname(__FILE__) + '/../init.rb'

  $SPEC_INITIALIZED = true
end