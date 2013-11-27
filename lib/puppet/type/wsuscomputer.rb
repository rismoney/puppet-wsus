Puppet::Type.newtype(:wsuscomputer) do
  @doc = "Manage WSUS Computers"
  ensurable

  newparam(:wsuscomputer) do
    desc "WSUS computer name."
    isnamevar
    validate do |value|
      raise Puppet::Error, "Computer name  must not be empty" if value.empty?
    end
  end
    
  newparam(:server) do
    desc 'Server with WSUS service.'
    validate do |value|
      raise Puppet::Error, "WSUS Server must not be empty" if value.empty?
    end
  end

  newparam(:wsusgroup) do
    desc 'Group to associate with Computer with'
    validate do |value|
      raise Puppet::Error, "WSUS Group must not be empty" if value.empty?
    end
  end
end
