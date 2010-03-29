require "#{File.dirname(__FILE__)}/spec_helper"

describe 'main application' do
  include Rack::Test::Methods

  def app
    Gitserved::Application
  end

  before(:each) do
    @id = '62ce8735d9db521de4c840d1a3975d3af420a596'
    Gitserved::Application.any_instance.stubs(:repo).returns(TestRepo.repo)
  end

  it 'should display data from current git head' do
    get '/'
    last_response.should be_ok
  end

  it 'should display data from a historical revision' do
    get "/index.html?rev=#{@id}"
    last_response.should be_ok
  end

  it 'should use revision stored in session' do
    get '/index.html', :session => { :rev => '123' }
    last_response.should be_ok
  end

  it 'should be a 404' do
    get '/index.html?rev=doesnotexist'
    last_response.should be_not_found
  end
end
