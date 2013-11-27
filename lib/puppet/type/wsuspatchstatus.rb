Puppet::Type.newtype(:wsuspatchstatus) do
  @doc = "Manage WSUS Patch Statuses"
  ensurable

  newparam(:patch) do
    desc 'Patch to Manage Status with'
    isnamevar
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

  newproperty(:wsusgroups, :array_matching => :all) do
    desc 'Group to associate with Computer with'
    validate do |value|
      raise Puppet::Error, "wsusgroups must not be empty" if value.empty?
    end
  end
end
