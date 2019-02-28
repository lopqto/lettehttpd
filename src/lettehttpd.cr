require "http"
require "option_parser"

# Default varibles
content_directory : String = "./"
listen_port : Int32 = 8080
listen_addr : String = "0.0.0.0"

# Main class
class LetteHttpd < HTTP::StaticFileHandler
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

OptionParser.parse! do |parser|
  parser.on("-h", "--help", "show this help message and exit") { puts parser; exit }
  parser.on("-d DIR", "--directory DIR", "specify a directory") { |dir| content_directory = dir }
  parser.on("-l ip:port", "--listen ip:port", "specify listen address and port") { |listen_vars| listen_addr = listen_vars.split(':')[0]; listen_port = listen_vars.split(':')[1].to_i }
end

# Running the server
server = HTTP::Server.new([
  HTTP::ErrorHandler.new,
  HTTP::LogHandler.new,
  HTTP::StaticFileHandler.new(content_directory),
])

server.bind_tcp listen_addr, listen_port
puts "Open the following url in your browser http://#{listen_addr}:#{listen_port}/"
server.listen
