# Windows Update Service must not be disabled for this to functional.
# In ISE environments, clients should be modified across the board to
# "Manual Start" via GPO.
#
# Hiera lookup `use_wsus` controls whether to bootstrap a client:
#
# true  => bootstrap to the defined wsus server
# false => do not bootstrap
#
#
# To use a new group:
#
# 1. create server groups on the wsus server
# 2. Modify wsus_groups key in ix-pm01.yaml
# 3. host-enforce the wsus server
# 4. host-enforce the client
#
# If you mess up the order, the client will not bootstrap correctly.
#
# :warning: wsusgroup does not yet support nested groups.
# Keep it simple.
#
# For more info, see:
# http://technet.microsoft.com/en-us/library/cc708449(v=ws.10).aspx
#
class wsus::client {

  # Defaults for this class
  Registry_value {
    ensure  => present,
  }

  # Registry keys are all in this part of the tree.
  $key_base = 'HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate'

  $wsus_server = hiera('wsus_server','')
  $wsus_port = hiera('wsus_port','8530')
  $connection_str = "http://${wsus_server}:${wsus_port}"

  $targetgroups = hiera_array('wsus_targetgroups',[])

  # Use client side group maps to align neatly with hiera.
  registry_value {"${key_base}\TargetGroupEnabled":
    type   => 'dword',
    data   => 1
  }

  # WSUS groups for the client. No nesting!
  registry_value {"${key_base}\TargetGroup":
    type   => 'string',
    data   => $targetgroups #semi-separated list
  }

  registry_value {"${key_base}\WUServer":
    type   => 'string',
    data   => $connection_str
  }

  registry_value {"${key_base}\WUStatusServer":
    type   => 'string',
    data   => $connection_str
  }

  registry_value {"${key_base}\AU\UseWUServer":
    type   => 'dword',
    data   => 1
  }

  # Do not run the service automatically.
  # We orchestrate via psmodule PSWindowsUpdate.
  registry_value {"${key_base}\AU\NoAutoUpdate":
    type   => 'dword',
    data   => 1
  }

  file {'wsus-register.ps1':
    ensure   => present,
    path     => 'c:/@inf/winbuild/scripts/wsus-register.ps1',
    source   => "puppet:///modules/${module_name}/wsus-register.ps1",
  }

  # Bootstrap the client to WSUS, but only if the
  # client moves to a different wsus target group.

  file {'PSWindowsUpdate.psm1':
    ensure    => present,
    path      => 'c:/tools/PSWindowsUpdate/PSWindowsUpdate.psm1',
    source    => "puppet:///modules/${module_name}/PSWindowsUpdate.psm1",
  }

  exec {'wsus-register':
    subscribe   => Registry_value["${key_base}\TargetGroup"],
    refreshonly => true,
    provider    => powershell,
    command     => 'c:/@inf/winbuild/scripts/wsus-register.ps1',
    require     => File['wsus-register.ps1']
  }

  file {'wsus-enforce.ps1':
    ensure    => present,
    path      => 'c:/@inf/winbuild/scripts/wsus-enforce.ps1',
    source    => "puppet:///modules/${module_name}/wsus-enforce.ps1",
  }

  file {'wsus-check.ps1':
    ensure    => present,
    path      => 'c:/@inf/winbuild/scripts/wsus-check.ps1',
    source    => "puppet:///modules/${module_name}/wsus-check.ps1",
  }
}
