puppet-wsus
===========

** Member of the rismoney suite of Windows Puppet Providers **

puppet wsus type/provider

What is WSUS?
Windows Server Update Services (WSUS) enables information technology administrators to deploy the latest Microsoft product updates to computers that are running the Windows operating system. By using WSUS, administrators can fully manage the distribution of updates that are released through Microsoft Update to computers in their network.

What is Puppet?
Puppet is IT automation software that helps system administrators manage infrastructure throughout its lifecycle, from provisioning and configuration to patch management and compliance. Using Puppet, you can easily automate repetitive tasks, quickly deploy critical applications, and proactively manage change, scaling from 10s of servers to 1000s, on-premise or in the cloud.

What is puppet-wsus?
It is a tool to manage WSUS with Puppet.

According to [sans] (http://www.sans.org/reading_room/whitepapers/bestprac/practical-methodology-implementing-patch-management-process_1206) 
an organization should have in place a strategy for establishing, documenting, maintaining and changing the
configuration of all servers and workstations according to their function.

This project's goal is to futher realize that goal on Windows Servers

Initial Requirements:
Minimum Windows Server 2008 R2
Leverage WSUS SP2 available here http://www.microsoft.com/en-us/download/details.aspx?id=5216
Leverage PoshWSUS available here http://poshwsus.codeplex.com/

Status:
An initial set of types are defined which present as the following:
Provider work is now underway

```puppet

wsusgroup {'win2012r2-prod':
  ensure  => present,
  server  => 'my-wsus-server.example.com',
}

wsuscomputer {'mypc.example.com':
  ensure         => present,
  wsusgroup      => 'win2012r2-prod',
  require        => Wsusgroup['win2012-prod'],
  server         => 'my-wsus-server.example.com',
}

wsuspatchstatus {'kb123456':
  ensure          => present # install|removal  (akin to present|absent),
  server          => 'my-wsus-server.example.com',
  require         => Wsusgroup['win2012-prod'],
  wsusgroups      => ['win2012r2-prod'],
}
```
