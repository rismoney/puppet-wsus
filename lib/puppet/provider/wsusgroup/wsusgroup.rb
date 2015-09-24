require File.join(File.dirname(__FILE__), '..', 'wsus')

Puppet::Type.type(:wsusgroup).provide(:wsusgroup, :parent => Puppet::Provider::Wsus) do
  desc "WSUS group"

    commands :poshexec =>
    if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
    elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
    else
      'powershell.exe'
    end

  mk_resource_methods

  def connectstring
   "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"
  end

  def self.instances
    connstr = "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"
    args = "#{connstr};(GET-PoshWSUSGroup).name"
    groupslist=poshexec(args)
    resources = Array.new
    groupslist.split(/\n+/).collect do |line|
      resources << new(
        :name => line,
        :ensure => :present
      )
    end
    resources
  end

  def self.prefetch(resources)
    debug("[prefetch(resources)]")
    Puppet.debug "wsusgroup prefetch instance: #{instances}"
    instances.each do |prov|
      Puppet.debug "wsusgroup prefetch instance resource: (#{prov.name})"
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present || false
  end

  def create
    connstr = connectstring
    args = "#{connstr};New-PoshWSUSGroup -Name \"#{@resource[:name]}\""
    poshexec(args)
  end

  def destroy
    connstr = connectstring
    args = "#{connstr};GET-PoshWSUSGroup -Name \"#{@resource[:name]}\" |Remove-PoshWSUSGroup"
    poshexec(args)
  end

end
