# require 'rubygems'
# require 'rubigraph'

# include Rubigraph

# Rubigraph.init

# v1 = Vertex.new
# v2 = Vertex.new
# e12 = Edge.new(v1,v2)
# sleep 10

require 'xmlrpc/client'

server = XMLRPC::Client.new2("http://127.0.0.1:20738/RPC2")

for id in (0..9)
  server.call("ubigraph.new_vertex_w_id", id)
end

for id in (0..9)
  server.call("ubigraph.new_edge", id, (id+1)%10)
end
