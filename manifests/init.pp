# == Class: vim_puppet
#
# Module to install and setup Pathogen and vim-puppet for a user
#
# === Parameters
#
# [*user_name*]
#   An array of user which you wish to setup vim-puppet for
#
# === Examples
#
#  class { vim_puppet:
#    $user_name => ['user1','user2','user3']
#  }
#
# === Authors
#
# Jason Cox <j_cox@globelock.dyndns.info>
#
# === Copyright
#
# Copyright 2014 Jason Cox, unless otherwise noted.
#
class vim_puppet (
  $user_name = pick($users,'undef'),

){
  package {'vim-enhanced':
    ensure => installed,
  } ->
  package {'vim-minimal':
    ensure => purged,
  } ->
  package {'git' :
    ensure => installed,
  } ->
  file {'/bin/vi' :
    ensure => '/usr/bin/vim',
    mode   => '755',
  } 
  if $user_name !=  'undef' {
    vim_puppet::setup { $user_name : }
  }
}
