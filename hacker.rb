require_relative './parser'
require_relative './code'
require_relative './symbol_table'
require 'pry-byebug'

class Hacker
  def initialize(args)
    @args = args
    file_path = @args[0]
    fd = IO.sysopen(file_path) #defaults to 'r'
    file_stream = IO.new(fd, 'r')
    new_path = File.basename(file_path, ".*")
    @output_file = File.new(File.dirname(__FILE__) + "/#{new_path}.hack", "w+")
    @parser = Parser.new(file_stream)
  end

  def run
    while @parser.hasMoreCommands
      @parser.advance
      if @parser.commandType == :C_COMMAND
        dest, comp, jump = @parser.c_parts
        binding.pry
        # address = SymbolTable::TABLE[@command.strip[1..-1].to_sym]
        line = '111' + Code::COMP[comp.to_sym] + Code::DEST[dest.to_sym] + Code::JMP[jump.to_sym]
      # "%016b" % address
      else
        line = @parser.symbol
      end
      @output_file.write(line+"\n")
    end
    binding.pry
    @output_file.close
  end
end
