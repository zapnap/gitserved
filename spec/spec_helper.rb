$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'gitserved'
require 'spec'
require 'spec/autorun'
require 'spec/interop/test'
require 'mocha'
require 'rack/test'

require "#{File.dirname(__FILE__)}/../lib/gitserved"

# set test environment
Gitserved::Application.set :environment, :test
Gitserved::Application.set :run, false
Gitserved::Application.set :raise_errors, true
Gitserved::Application.set :logging, false

Spec::Runner.configure do |config|
  config.mock_with(:mocha)
end

class TestRepo
  def initialize; end 

  def repo
    if @repo
      @repo
    else
      tmp_dir = File.join(File.dirname(__FILE__), 'tmp')
      `git clone git://github.com/zapnap/zapnap.github.com.git #{tmp_dir}` unless File.exists?(tmp_dir)

      @repo = Grit::Repo.new(tmp_dir)
    end 
  end 

  def self.repo
    self.new.repo
  end
end
