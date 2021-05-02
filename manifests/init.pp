# @summary Simplicistic module to manage Slurm installation
#
# This module currently helps to install. However it does not
# configure Slurm in terms of contents in /etc/slurm (slurm.conf,
# gres.conf, ...). Currently the module manages:
# * Installation of RPMs for given role
# * Creation of user and group slurm
#
# Note on config: Just store contents of `/etc/slurm` in a git repo
# and clone it on your shared filesystem to the final path using
# `puppetlabs-vcsrepo`.
#
# @example
#   class { 'slurm':
#
class slurm (
  Boolean $client,
  Boolean $slurmd,
  Boolean $slurmdbd,
  Boolean $slurmctld,
  String  $package_ensure,
  # Slurm user and group management related options
  Boolean $manage_slurm_user,
  String  $slurm_user,
  Integer $slurm_user_uid,
  String  $slurm_user_group,
  Integer $slurm_user_group_gid,
  # Services ensures
  Boolean $reload_services,
  Boolean $restart_services,
  String  $slurmd_service_ensure,
  String  $slurmdbd_service_ensure,
  String  $slurmctld_service_ensure,
  # Other options
  Boolean $manage_logrotate,
) {

  ### Hardcoded options currently not overridable ###
  # Slurm user and group management related options
  $slurm_user_shell      = '/sbin/nologin'
  $slurm_user_home       = '/var/lib/slurm'
  $slurm_user_managehome = true
  $slurm_user_comment    = 'SLURM User'
  # Managed directories
  $conf_dir = '/etc/slurm'
  $log_dir  = '/var/log/slurm'

  # Compute which services and how to notify on changes
  if $slurmd and $slurmd_service_ensure == 'running' and $reload_services and $facts['slurmd_version'] {
    $slurmd_notify = Exec['slurmd reload']
  } elsif $slurmd and $slurmd_service_ensure == 'running' and $restart_services {
    $slurmd_notify = Service['slurmd']
  } else {
    $slurmd_notify = undef
  }

  if $slurmctld and $slurmctld_service_ensure == 'running' and $reload_services and $facts['slurmctld_version'] {
    $slurmctld_notify = Exec['scontrol reconfig']
  } elsif $slurmctld and $slurmctld_service_ensure == 'running' and $restart_services {
    $slurmctld_notify = Service['slurmctld']
  } else {
    $slurmctld_notify = undef
  }

  if $slurmdbd and $slurmdbd_service_ensure == 'running' and $reload_services and $facts['slurmdbd_version'] {
    $slurmdbd_notify = Exec['slurmdbd reload']
  } elsif $slurmdbd and $slurmdbd_service_ensure == 'running' and $restart_services {
    $slurmdbd_notify = Service['slurmdbd']
  } else {
    $slurmdbd_notify = undef
  }
  # finally combine the ones not undef to an array for later use in slurm::common::install
  $service_notify = flatten([$slurmd_notify, $slurmctld_notify, $slurmdbd_notify]).filter |$val| { $val =~ NotUndef }

  if ! ($client or $slurmd or $slurmdbd or $slurmctld) {
    fail('No slurm feature has been selected. Select at least one of client, slurmd, slurmctld or slurmdbd.')
  }

  if $client {
    contain slurm::client
  }

  if $slurmd {
    contain slurm::slurmd
  }

  if $slurmdbd {
    contain slurm::slurmdbd
  }

  if $slurmctld {
    contain slurm::slurmctld
  }
}
