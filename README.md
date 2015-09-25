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

The initial approach is to:
* Define a set of patch groups
* Assign Patches to Patch Groups
* Let Puppet do the needful, and let Automatic Updates do the needful

Initial Requirements:

* Development being performed on Win2012 using integrated Feature/Roles
* Most likely supports  Windows Server 2008 R2 with [WSUS SP2](httpo://www.microsoft.com/en-us/download/details.aspx?id=5216)
* Leverage PoshWSUS

Status:
* Provider is currently functional
* Added prefetching!  Woot!

TODO
* Rpec: haven't tried a slew of use cases and edge cases

Usage:

```puppet

wsusgroup {'win2012r2-prod':
  ensure  => present,
  server  => 'my-wsus-server.example.com',
}

wsuspatchstatus {'kb123456-win2012-prod': # this should be unique
  ensure          => present # install|removal  (akin to present|absent),
  patch           => 'kb123456' #this is the real namevar
  server          => 'my-wsus-server.example.com',
  require         => Wsusgroup['win2012-prod'],
  wsusgroup      => 'win2012r2-prod',
}

# if you do not use client side targetting this is also available:

wsuscomputer {'mypc.example.com':
  ensure         => present,
  wsusgroup      => 'win2012r2-prod',
  require        => Wsusgroup['win2012-prod'],
  server         => 'my-wsus-server.example.com',
}


```
