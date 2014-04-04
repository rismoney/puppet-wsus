define wsus::patch_iter {

  $patchlist = hiera($name, {})
  $patch_arr = keys($patchlist)

  $patchnames = suffix($patch_arr,"-${name}")

  wsus::patch {$patchnames:}
}
