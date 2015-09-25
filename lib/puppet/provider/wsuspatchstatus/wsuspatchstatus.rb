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
      line.split(/\s{2,}/)
    end

    patchlist_grouped = formatted_patchlist.group_by{|x| x[0]}.map{|a,b| b.join(',').split(',').uniq * ',' }
    patchlist_grouped.each do |patchandgroup|
      patchandgroup_array = patchandgroup.split(',')
      patchno = patchandgroup_array[0]
      wsusgrouplist = patchandgroup_array[1..-1]
      if patchno
        instances << new(
          :ensure => :present,
          :patch => "kb#{patchno}",
          :wsusgroups => wsusgrouplist
        )
      end
    end
    instances
  end

  def self.prefetch(resources)
    instances.each do |prov|
    Puppet.debug "wsuspatch prefetch instance resource: (#{prov.patch})"
      if resource = resources[prov.patch]
        resource.provider = prov
      end
    end
  end

  def connectstring
    "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"
  end

  def exists?
    if @property_hash[:wsusgroups].nil?
      return false
    else
      extraneous = @resource[:wsusgroups] - @property_hash[:wsusgroups]
      return true if extraneous.empty?
    end
  end

  def wsusgroups
    return @property_hash[:wsusgroups]
  end

  def wsusgroups=(newvalue)
     kbnumber = @resource[:patch].sub(/kb/,'')
     connstr = connectstring
     newvalue.each { |wsusgroup|
       args = "#{connstr};Approve-PoshWSUSUpdate -Group \"#{wsusgroup}\" -Update \"#{kbnumber}\" -Action Install"
       poshexec(args)
     }
  end

  def create
    self.wsusgroups = @resource[:wsusgroups]
  end

  def destroy
    connstr = connectstring
    kbnumber = @resource[:patch].sub(/kb/,'')
    @resource[:wsusgroups].each { |wsusgroup|
      args = "#{connstr};Approve-PoshWSUSUpdate -Group \"#{wsusgroup}\" -Update \"#{kbnumber}\" -Action NotApproved"
      poshexec(args)
     }
  end

end
