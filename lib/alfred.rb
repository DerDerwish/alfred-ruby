#require 'json'

class Alfred
  attr_accessor :filename, :filetype, :graph
  
  def initialize(filename, filetype=File.extname(filename))
    raise ArgumentError, 'Argument is empty' unless not filename.empty?
    raise ArgumentError, 'File ist not available' unless File.exists?(filename)
    @filename = filename
    @filetype = filetype
  end
  
  def update()
    content = ""
    file = File.open(@filename, "r") do |f|
      f.each_line do |line|
        content += line
      end
    end
    if @filetype == ".dot" then
      #parse_dot(content)
    else
      @graph = parse_json(content)
    end
  end
  
  def parse_dot(data)
    
  end
  
  def parse_json(data)
    graph = Graph.new
    primaries = []
    secondaries = []
    clients = []
    data.each_line do |line|
      if line.start_with?('{ "primary" :') then
        primaries.push(line.split('"')[3])
      elsif line.start_with?('{ "secondary" :') then
        secondaries.push([line.split('"')[3],line.split('"')[7]])
      elsif line.end_with?(': "TT" }')
        Clients.push(line.split('"')[7])
      end
    end
    
    primaries.each do |primary|
      graph.add_node(primary)
    end
    
    return graph
  end
end

class Graph
  attr_accessor :nodes
  
  def initialize
    self.nodes = []
  end
  
  def add_node(mac_address)
    self.nodes.push(Node.new(mac_address))
  end
  
  def get_node_by_mac_address(mac_address)
    #return self.nodes.select(|a| a.get_primary_mac_address().equals(mac_address))
  end
  
end

class Node
  attr_accessor :primary_mac_address, :secondary_mac_addresses, :clients, :neighbours
      
  def initialize(mac_address)
    self.primary_mac_address = mac_address
    self.clients = []
    self.neighbours = []
    self.secondary_mac_addresses = []
  end
  
  def get_primary_mac_address()
    return self.primary_mac_address
  end
  
  def add_client(mac_address)
    self.clients.push(Client.new(mac_address))
  end
  
  def add_neighbour(mac_address)
    self.neighbours.push(mac_address)
  end
  
end
class Client
  attr_accessor :mac_address
end