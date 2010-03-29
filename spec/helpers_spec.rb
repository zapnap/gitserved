require "#{File.dirname(__FILE__)}/spec_helper"

describe 'Gitserved::Helpers' do
  include Gitserved::Helpers::FileHelper
  include Gitserved::Helpers::GitHelper

  context 'file helpers' do
    it 'should auto-append index.html' do
      file_path('/').should == '/index.html'
    end
  end

  context 'git helpers' do
    before(:each) do
      stubs(:repo).returns(TestRepo.repo)
      @id = '62ce8735d9db521de4c840d1a3975d3af420a596'
    end

    it 'should retrieve the latest revision' do
      head.is_a?(Grit::Commit).should be_true
      head.id.should == repo.commits.first.id
    end

    it 'should retrieve a specific revision' do
      revision(@id).is_a?(Grit::Commit).should be_true
      revision(@id).id.should == @id
    end

    it 'should retrieve a blob from head' do
      git_path('/index.html').is_a?(Grit::Blob).should be_true
      git_path('/index.html').name.should == 'index.html'
    end

    it 'should retrieve a blob from a specific revision' do
      git_path('/index.html', @id).is_a?(Grit::Blob).should be_true
      git_path('/index.html', @id).name.should == 'index.html'
      git_path('/index.html', @id).id.should == '49a00d8e2fe0c423a254639643ec41910a504bf3'
    end

    it 'should raise GitReadError' do
      lambda {
        git_path('/index.html', 'doesnotexist')
      }.should raise_error(Gitserved::GitReadError)
    end
  end
end
