#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../../../spec_helper'
require 'puppet'
require 'puppet/type'
require 'puppet/provider/wsusgroup/wsusgrp'

provider_class = Puppet::Type.type(:wsusgroup).provider(:wsusgrp)

describe provider_class do
  before do
    @resource = stub("resource", :name => "foo")
    @provider = provider_class.new(@resource)
  end


  describe "when an instance" do
    before do
      @instance = provider_class.new(:wsusgroup)
    end

    it "should have a method for creating the instance" do
      @instance.should respond_to(:create)
    end

    it "should have a method for removing the instance" do
      @instance.should respond_to(:destroy)
    end
  
    it "should indicate when the instance already exists" do
      @instance = provider_class.new(:ensure => :present)
      @instance.exists?.should be_true
    end
  end
end
