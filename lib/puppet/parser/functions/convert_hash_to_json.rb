require "json"
module Puppet::Parser::Functions
  newfunction(:convert_hash_to_json, :type => :rvalue) do |args|
#    raise(Puppet::ParseError, "join_machine_list() wrong number of arguments. Given: #{args.size} for 2)") if args.size !=2
    puppet_hash = args[0]
    json_hash = JSON.pretty_generate(puppet_hash)
    return json_hash
  end
end
