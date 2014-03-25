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

  newproperty(:wsusgroups, :array_matching => :all) do
    desc 'Group to associate with Computer with'
    def insync?(is)
    # The current value may be nil and we don't
    # want to call sort on it so make sure we have arrays
      if is.is_a?(Array) and @should.is_a?(Array)
        is.sort == @should.sort
      else
        is == @should
      end
    end

    
    validate do |value|
      raise Puppet::Error, "wsusgroups must not be empty" if value.empty?
    end
  end
end
