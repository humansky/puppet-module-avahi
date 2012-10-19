# == Class: avahi
#
#  This module sets up avahi on EL based systems.
#
#
#  Requirements:
#    cprice404-inifile >= 0.0.3
#
# === Parameters
#
# === Examples
#
#  class { avahi:  }
#
# === Authors
#
# Michael Stahnke <stahnma@fedoraproject.org>
#
# === Copyright
#
# Copyright 2012 Michael Stahnke


class avahi inherits avahi::params {

#    $avahi_pkgs = [ 'avahi', 'avahi-tools', 'nss-mdns' ]
#     $avahi_main    = 'avahi'
#         $avahi_daemon  = 'avahi-daemon'
#             $avahi_tools   = 'avahi_tools'
#                 $avahi_mdns    = 'nss-mdns'
# $avahi_dbus = 'dbus' or 'messagebus'
#
   package { $avahi_main:
     ensure  => installed,
   }
   package { $avahi_tools:
     ensure  => installed,
     require => Package[$avahi_main]
   }
   package { $avahi_mdns:
     ensure  => installed,
     require => Package[$avahi_main]
   }

   service { $avahi_daemon:
     ensure    => running,
     enable    => true,
     hasstatus => true,
     require   => Service[$avahi_dbus],
   }

   service { $avahi_dbus:
     ensure  => running,
     enable  => true,
     require => Package[$avahi_mdns],
   }

  ini_setting { "avahi-${::hostname}":
    ensure  => present,
    path    => '/etc/avahi/avahi-daemon.conf',
    section => 'server',
    setting => 'host-name',
    key_val_separator => '=',
    value   => $::hostname,
    notify  => Service[$avahi_daemon],
    require => Package[$avahi_mdns],
  }

}
