module Gitserved
  class Application < Sinatra::Base
    configure do
      enable :sessions
      set :root, Dir.pwd
    end

    error do
      e = request.env['sinatra.error']
      Kernel.puts(e.backtrace.join('\n'))
      'Application Error'
    end

    helpers do
      include Gitserved::Helpers::FileHelper
      include Gitserved::Helpers::GitHelper
    end

    before do
      query_string = request.query_string.split('&').map { |pair| pair.split('=') }
      if rev_string = query_string.find { |opt| opt.first == 'rev' }
        session[:rev] = rev_string.last
      end
    end

    get '*' do
      pass if params[:splat].first.match(/__sinatra__/)

      path = file_path(params[:splat].first)
      # puts "requested #{path}"
      # puts "with commit hash #{session[:rev]}" if session[:rev]

      begin
        git_path(path, session[:rev]).data
      rescue GitReadError
        raise Sinatra::NotFound
      end
    end
  end
end
