require File.join(File.dirname(__FILE__), '..', 'wsus')

Puppet::Type.type(:wsuspatchstatus).provide(:wsuspatchstatus, :parent => Puppet::Provider::Wsus) do
  desc "WSUS patch status"

    commands :poshexec =>
    if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
    elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
    else
      'powershell.exe'
    end

  mk_resource_methods

  def self.instances
    connstr = "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"
    args = "#{connstr};Get-PoshWSUSUpdateApproval | Where-Object {$_.action -ne 'NotApproved'} |Sort-Object -Property UpdateKB |ft -hidetableheaders UpdateKB,targetgroup"
    instances = []
    patchlist=poshexec(args)

    patchlist_array_of_lines = patchlist.split(/\n+/)
    formatted_patchlist = patchlist_array_of_lines.collect do |line|
      if line.empty? ; next; end
      values = line.split(/\s{2,}/)

      patchno = values[0]
      wsusgroup = values[1]
      instances << new(
        :name => "kb#{patchno}-#{wsusgroup}",
        :ensure => :present,
        :patch => "kb#{patchno}",
        :wsusgroup => wsusgroup
        )
      end

    instances
  end

  def self.prefetch(resources)
    instances.each do |prov|
    Puppet.debug "wsuspatch prefetch instance resource: (#{prov.name})"
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def connectstring
   "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"
  end

  def exists?
    @property_hash[:ensure] == :present || false
  end

  def wsusgroup
    return @property_hash[:wsusgroup]
  end

  def wsusgroup=(newvalue)
     kbnumber = @resource[:patch].sub(/kb/,'')
     connstr = connectstring
     args = "#{connstr};Approve-PoshWSUSUpdate -Group \"#{newvalue}\" -Update \"#{kbnumber}\" -Action Install"
     poshexec(args)
  end

  def create
    self.wsusgroup = @resource[:wsusgroup]
  end

  def destroy
    connstr = connectstring
    kbnumber = @resource[:patch].sub(/kb/,'')
    args = "#{connstr};Approve-PoshWSUSUpdate -Group \"#{@resource[:wsusgroup]}\" -Update \"#{kbnumber}\" -Action NotApproved"
    poshexec(args)
  end

end
