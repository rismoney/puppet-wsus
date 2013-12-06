#! /usr/bin/env ruby
require File.dirname(__FILE__) + '/../../../../spec_helper'
require 'puppet'
require 'puppet/type'
require 'puppet/provider/wsusgroup/wsusgroup'

provider =  Puppet::Type.type(:wsusgroup).provider(:wsusgroup)
  
describe provider do

  let(:poshexec) {                                                                                                                                                                    
      if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
        "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
      elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
        "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
      else 
        'powershell.exe'
      end
  }  

  before :each do
    @resource = Puppet::Type.type(:wsusgroup).new(
      :name   => "wsusgroup",
      :ensure => :present,
      :server => "server.example.com"
    )
    @provider = provider.new(@resource)
    provider.stubs(:healthcheck)
  end

  context "when an instance" do
    it "should have a method for creating the instance" do
      @provider.should respond_to(:create)
    end

    it "should have a method for removing the instance" do
      @provider.should respond_to(:destroy)
    end

    it "should have an exists? method" do
      @provider.should respond_to(:exists?)
    end
  end
 
  context "#create" do
    it "should execute wsusgroup create" do
      @provider.expects(:wsusgroup).with('create', poshexec)
      @provider.create
    end
  end
end
