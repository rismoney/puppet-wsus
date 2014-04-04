define wsus::patch {

  $pg = split($title,'-')

  $patch = $pg[0]
  $patchgroup = $pg[1]

  $wsus_server = hiera('wsus_server','')

  $wsus_grouppatches = hiera($patchgroup,{})
  $patchstate = $wsus_grouppatches[$patch][ensure]

  wsuspatchstatus {$title:
    ensure     => $patchstate,
    patch      => $patch,
    server     => $wsus_server,
    require    => Wsusgroup[$patchgroup],
    wsusgroups => [$patchgroup],
  }
}
