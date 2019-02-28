require "option_parser"

# Defaults varibles
content_directory = "./"
listen_port = 8080
listen_addr = "0.0.0.0"

OptionParser.parse! do |parser|
    parser.on("-h", "--help", "show this help message and exit") { puts parser; exit }
    parser.on("-d DIR", "--directory DIR", "specify a directory") { |dir| content_directory = dir }
    parser.on("-l ip:port", "--listen ip:port", "specify listen address and port") { |listen_vars| listen_addr, listen_port = listen_vars.split(':') }
end
