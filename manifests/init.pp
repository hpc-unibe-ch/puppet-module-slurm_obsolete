# == Class: slurm
#
# Module for provisioning and managing of nodes in a SLURM cluster
# 
# This class only makes the default parameters available in a more 
# secure fashion for later use
#
# === Parameters
#
# none
#
class slurm (
  $is_slurm_master     = $slurm::params::is_slurm_master,
  $is_slurm_worker     = $slurm::params::is_slurm_worker,
  $is_slurm_db         = $slurm::params::is_slurm_db,
  $is_slurm_login      = $slurm::params::is_slurm_login,
  $disable_munge       = $slurm::params::disable_munge,
  $disable_pam         = $slurm::params::disable_pam,
  $manage_user_locally = $slurm::params::manage_user_locally,
  $slurm_user          = $slurm::params::slurm_user,
  $slurm_user_id       = $slurm::params::slurm_user_id,
  $slurm_group         = $slurm::params::slurm_group,
  $slurm_group_id      = $slurm::params::slurm_group_id,
  $munge_user          = $slurm::params::munge_user,
  $munge_user_id       = $slurm::params::munge_user_id,
  $munge_group         = $slurm::params::munge_group,
  $munge_group_id      = $slurm::params::munge_group_id,
  $munge_key           = $slurm::params::munge_key,
) inherits slurm::params {

  if $slurm::is_slurm_master {
    include slurm::common
    include slurm::master::install
    include slurm::master::config
    include slurm::master::service

    Class['slurm::common'] ->
    Class['slurm::master::install']->
    Class['slurm::master::config']->
    Class['slurm::master::service']
  }

  if $slurm::is_slurm_worker {
    include slurm::common
    include slurm::worker::install
    include slurm::worker::config
    include slurm::worker::service

    Class['slurm::common'] ->
    Class['slurm::worker::install']->
    Class['slurm::worker::config']->
    Class['slurm::worker::service']
  }

  if $slurm::is_slurm_db {
    include slurm::common
    include slurm::db::install
    include slurm::db::config
    include slurm::db::service

    Class['slurm::common'] ->
    Class['slurm::db::install']->
    Class['slurm::db::config']->
    Class['slurm::db::service']
  }

  if $slurm::is_slurm_login {
    include slurm::login::config
  }

}

