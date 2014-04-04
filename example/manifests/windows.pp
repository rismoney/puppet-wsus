class wsus::windows {

  $use_wsus = hiera('use_wsus',false)
  $wsus_server = hiera('wsus_server','')
  if $use_wsus == true {
    include wsus::client
  }

  # this configures the wsus server
  if $::ise_mock_fqdn == $wsus_server {
    include wsus::server
  }
}
