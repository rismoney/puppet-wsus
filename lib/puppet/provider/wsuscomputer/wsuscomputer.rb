require File.join(File.dirname(__FILE__), '..', 'wsus')

Puppet::Type.type(:wsuscomputer).provide(:wsuscomputer, :parent => Puppet::Provider::Wsus) do
  desc "WSUS computer"

    commands :poshexec =>
    if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
    elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
    else
      'powershell.exe'
    end

  @@connstr= "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"

  def exists?
    rc=false
    args = "#{@@connstr};(GET-PoshWSUSClient -Computer \"#{@resource[:name]}\").computergroup"
    groups=poshexec(args)
    rc=true if groups.include?(@resource[:wsusgroup])
    return rc
  end

  def create
    args = "#{@@connstr};Add-PoshWSUSClientToGroup -group \"#{@resource[:wsusgroup]}\" -computer \"#{@resource[:name]}\""
    poshexec(args)
  end

  def destroy
    args = "#{@@connstr};Remove-PoshWSUSClientFromGroup -group \"#{@resource[:wsusgroup]}\" -computer \"#{@resource[:name]}\""
    poshexec(args)
  end

end
