require 'spec_helper'
require 'puppetlabs_spec_helper/puppetlabs_spec/puppet_internals'

describe "convert_hash_to_json" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }
  it "should exist" do
    expect(Puppet::Parser::Functions.function("convert_hash_to_json")).to eq("function_convert_hash_to_json")
  end

  context 'test output for' do
    it "one group" do
      result = scope.function_convert_hash_to_json([{'group1' => ['user1', 'user2']}])
        expected = %Q({
  "group1": [
    "user1",
    "user2"
  ]
})
        
#        '{\n  "group1": [\n    "user1",\n    "user2"\n  ]\n}'
      expect(result).to match(expected)
    end
    it "two groups" do
      result = scope.function_convert_hash_to_json([{'group1' => ['user1', 'user2'], 'group2' => ['user3', 'user4']}])
        expected = %Q({
  "group1": [
    "user1",
    "user2"
  ],
  "group2": [
    "user3",
    "user4"
  ]
})
      expect(result).to eq(expected)
    end
  end
end
