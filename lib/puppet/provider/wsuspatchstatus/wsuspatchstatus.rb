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

  def connectstring
   "import-module poshwsus | out-null; $null=(Connect-PoshWSUSServer localhost -port 8530)"
  end

  def exists?
    kbnumber = @resource[:patch].sub(/kb/,'')
    #poshregex='('+(@resource[:wsusgroups].join(',')).gsub(',',')|(')+')'
    connstr = connectstring
    args = "#{connstr};(Get-PoshWSUSUpdateApproval | Where-Object {$_.updatekb -eq \"#{kbnumber}\"} | Sort-Object -Property TargetGroup -Unique).Targetgroup"
    approvals=Array(poshexec(args))
    approvals.map {|x| x.chomp!}
    extraneous = @resource[:wsusgroups] - approvals
    return true if extraneous.empty?
  end

  def wsusgroups
    kbnumber = @resource[:patch].sub(/kb/,'')
    connstr = connectstring
    args = "#{connstr};(Get-PoshWSUSUpdateApproval | Where-Object {$_.updatekb -eq \"#{kbnumber}\"} | Sort-Object -Property TargetGroup -Unique).Targetgroup"
    approvals=Array(poshexec(args))
    approvals.map {|x| x.chomp!}
    return approvals
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
    kbnumber = @resource[:patch].sub(/kb/,'')
    @resource[:wsusgroups].each { |wsusgroup|
      args = "#{@@connstr};Approve-PoshWSUSUpdate -Group \"#{wsusgroup}\" -Update \"#{kbnumber}\" -Action Removal"
      poshexec(args)
     }
  end

end
