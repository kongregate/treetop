require 'rubygems'
require 'spec'

dir = File.dirname(__FILE__)
require "#{dir}/../spec_helper"

describe ParseFailure do
  setup do
    @matched_interval_begin = 0
    @parse_failure_forre = ParseFailure.new(@matched_interval_begin)
  end
  
  it "should be failure" do
    @parse_failure_forre.should be_failure
  end
  
  it "should not be success" do
    @parse_failure_forre.should_not be_success
  end 
  
  it "has a zero length interval at the beginning of its match interval" do
    @parse_failure_forre.interval.should == (@matched_interval_begin...@matched_interval_begin)
  end
  
  it "has an empty array of nested failures" do
    @parse_failure_forre.nested_failures.should == []
  end
end

describe ParseFailure, " instantiated with nested failures at various indices" do
  before(:each) do
    @index = 0
    @nested_failures = [5, 5, 3, 0].collect {|index| terminal_parse_failure_at(index)}
    @failure = ParseFailure.new(@index, @nested_failures)
  end
  
  it "retains those nested failures with the highest index" do
    nested_failures = @failure.nested_failures
    nested_failures.size.should == 2
    nested_failures[0].index.should == 5
    nested_failures[1].index.should == 5
  end
end