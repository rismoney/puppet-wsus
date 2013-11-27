Puppet::Type.newtype(:wsusgroup) do
  @doc = "Manage WSUS Groups"
  ensurable

  newparam(:wsusgroup) do
    desc "WSUS group name."
    isnamevar
    validate do |value|
      raise Puppet::Error, "Group name  must not be empty" if value.empty?
    end
  end
    
  newparam(:server) do
    desc 'Server with WSUS service.'
    validate do |value|
      raise Puppet::Error, "Name must not be empty" if value.empty?
    end
  end
end
