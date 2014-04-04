class wsus::server {

  $wsus_server = hiera('wsus_server','')
  $wsus_groups = hiera('wsus_groups',{})
  $group_arr = keys($wsus_groups)

  $defaults = {
    'server' => $wsus_server
  }

  create_resources(wsusgroup, $wsus_groups, $defaults)

  file {'Fetch-WSUS.ps1':
    ensure   => present,
    path     => 'C:/@inf/winbuild/scripts/Fetch-WSUS.ps1',
    source   => "puppet:///modules/${module_name}/Fetch-WSUS.ps1",
  }

  file {'wsus-groupdiff.ps1':
    ensure   => present,
    path     => 'C:/@inf/winbuild/scripts/wsus-groupdiff.ps1',
    source   => "puppet:///modules/${module_name}/wsus-groupdiff.ps1",
  }

  file {'wsus-stale.ps1':
    ensure   => present,
    path     => 'C:/@inf/winbuild/scripts/wsus-stale.ps1',
    source   => "puppet:///modules/${module_name}/wsus-stale.ps1",
  }

  file {'wsus-reset.ps1':
    ensure   => present,
    path     => 'C:/@inf/winbuild/scripts/wsus-reset.ps1',
    source   => "puppet:///modules/${module_name}/wsus-reset.ps1",
  }

  wsus::patch_iter {$group_arr:}
}
