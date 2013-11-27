require 'puppet'

require File.dirname(__FILE__) + '/../../../spec_helper'

describe Puppet::Type.type(:wsusgroup) do

  it do
    expect {
      Puppet::Type.type(:wsusgroup).new(:name => '')
    }.to raise_error(Puppet::Error, /wsusgroup must not be empty/)
  end

  params = [
  'wsusgroup',
  'server',
  ].each do |param|
    context "when a valid wsusgroup parameter #{param} => is specified (std string)" do
      it "should not raise an error" do
        expect {
          Puppet::Type.type(:wsusgroup).new(:name => param, param => "blah")
          }.to_not raise_error
      end
    end
  end

  
# check to make sure a bullshit params raises an error 
  params = [
  'booya',
  '123',
  ].each do |param|
    context "when param used is #{param}" do
      it "should fail if the resourcetype #{param} is not valid" do
        expect {
          Puppet::Type.type(:wsusgroup).new(:name => param, param => 'boooya')
          }.to raise_error
      end
    end
  end

end
