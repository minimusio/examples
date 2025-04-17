#!/usr/bin/env ruby

class MinimusFact
    attr_accessor :source
  
    def initialize(source = "containers.txt")
      @source = source
    end
  
    def random_line
      puts File.readlines(@source).sample
    end
  end
  
  if __FILE__ == $0
    fact = MinimusFact.new
    fact.random_line
  end