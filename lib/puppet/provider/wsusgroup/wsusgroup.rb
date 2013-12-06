Puppet::Type.type(:wsusgroup).provide :wsusgroup do
  desc "WSUS group"

    commands :poshexec =>
    if File.exists?("#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\sysnative\\WindowsPowershell\\v1.0\\powershell.exe"
    elsif File.exists?("#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe")
      "#{ENV['SYSTEMROOT']}\\system32\\WindowsPowershell\\v1.0\\powershell.exe"
    else
      'powershell.exe'
    end

  @@connstr= 'import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)'

  def exists?
    rc=false
    args = "#{@@connstr};(GET-PoshWSUSGroup -Name \"#{@resource[:name]}\").Name"
    group=poshexec(args)
    (group.each {|group| group  && rc=true})
    return rc
  end

  def create
    args = "#{@@connstr};New-PoshWSUSGroup -Name \"#{@resource[:name]}\""
    poshexec(args)
  end

  def destroy
    args = "#{@@connstr};GET-PoshWSUSGroup -Name \"#{@resource[:name]}\" |Remove-PoshWSUSGroup"
    poshexec(args)
  end

end
