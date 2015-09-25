Puppet::Type.newtype(:wsuspatchstatus) do
  @doc = "Manage WSUS patches"
  ensurable

  newparam(:name) do
    desc 'Name'
    isnamevar
  end

  newparam(:patch) do
    desc 'Patch to Manage Status with'
    validate do |value|
      raise Puppet::Error, "patch must not be empty" if value.empty?
    end
  end

  newparam(:server) do
    desc 'Server with WSUS service.'
    validate do |value|
      raise Puppet::Error, "server must not be empty" if value.empty?
    end
  end

  newproperty(:wsusgroup) do
    desc 'Group to associate with Computer with'
    validate do |value|
      raise Puppet::Error, "wsusgroups must not be empty" if value.empty?
    end
  end
end
