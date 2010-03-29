$:.unshift File.expand_path(File.dirname(__FILE__))
require 'rubygems'

require 'grit'
require 'gitserved/helpers'

module Gitserved
  include Grit

  VERSION ||= '0.1'

  class GitReadError < StandardError; end
end

require 'sinatra' unless defined?(Sinatra)
require 'gitserved/application'
