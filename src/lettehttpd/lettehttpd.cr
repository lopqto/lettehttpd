require "http"

module LetteHttpd

    class StaticFileHandler < HTTP::StaticFileHandler
        def call(context)
            # Rewrite path
            if context.request.path.ends_with?("/")
                index_path = context.request.path + "index.html"
                index_realpath = @public_dir + index_path
      
                if File.exists?(index_realpath)
                    context.response.status_code = 200
                    context.request.path = index_path
                end
            end
      
            # Add server name
            context.response.headers["Server"] = "LetteHttpd"
            super
        end
    end
    
end
