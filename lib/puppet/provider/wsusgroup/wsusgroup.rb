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

  def connectstring
   "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"
  end

  def exists?
    rc=false
  connstr = connectstring
    args = "#{connstr};(GET-PoshWSUSGroup -Name \"#{@resource[:name]}\").Name"
    group=poshexec(args).chomp
    rc=true if group==@resource[:name]
    return rc
  end

  def create
    connstr = connectstring
    args = "#{connstr};New-PoshWSUSGroup -Name \"#{@resource[:name]}\""
    poshexec(args)
  end

  def destroy
    connstr = connectstring
    args = "#{@@connstr};GET-PoshWSUSGroup -Name \"#{@resource[:name]}\" |Remove-PoshWSUSGroup"
    poshexec(args)
  end
end
