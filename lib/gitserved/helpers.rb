module Gitserved
  module Helpers
    module FileHelper
      def file_path(path)
        if File.extname(path) == '' || path[-1] == 47
          "#{path}index.html"
        else
          path
        end
      end
    end

    module GitHelper
      def repo
        ::Gitserved::Repo.new(Dir.pwd)
      end

      def head
        repo.commits.first
      end

      def revision(id)
        repo.commits(id).first
      end

      # id can be any commit hash, etc
      # defaults to latest (HEAD) revision
      def git_path(path, id = nil)
        obj = id.nil? ? head.tree : revision(id).tree
        path.split('/').each do |part|
          next if part == ''
          obj = obj / part
        end

        obj
      rescue NoMethodError
        raise ::Gitserved::GitReadError.new
      end
    end
  end
end
