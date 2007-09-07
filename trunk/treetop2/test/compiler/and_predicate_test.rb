require File.join(File.dirname(__FILE__), '..', 'test_helper')

describe "An &-predicated terminal symbol", :extend => CompilerTestCase do
  testing_expression_2 '&"foo"'
  
  it "successfully parses input matching the terminal symbol, returning an epsilon syntax node" do
    parse('foo') do |result|
      result.should be_success
      result.interval.should == (0...0)
    end
  end
end

describe "A sequence of a terminal and an and another &-predicated terminal", :extend => CompilerTestCase do
  testing_expression_2 '"foo" &"bar"'

  it "matches input matching both terminals, but only consumes the first" do
    parse('foobar') do |result|
      result.should be_success
      result.text_value.should == 'foo'
    end
  end
  
  it "fails to parse input matching only the first terminal, with the nested failure of the second" do
    parse('foo') do |result|
      result.should be_failure
      result.nested_failures.size.should == 1
      nested_failure = result.nested_failures[0]
      nested_failure.index.should == 3
      nested_failure.expected_string.should == 'bar'
    end
  end
end