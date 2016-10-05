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
  $disable_munge       = $slurm::params::disable_munge,
  $disable_pam         = $slurm::params::disable_pam,
  $manage_user_locally = $slurm::manage_user_locally,
  $munge_key           = $slurm::params::munge_key,
  $slurm_conf_dir      = $slurm::params::slurm_conf_dir,
) inherits slurm::params {

  include slurm::common
  
  if $slurm::is_slurm_master {
    include slurm::master::install
    include slurm::master::config
    include slurm::master::service
  }

  if $slurm::is_slurm_worker {
    include slurm::worker::install
    include slurm::worker::config
    include slurm::worker::service
  }

  if $slurm::is_slurm_db {
    include slurm::db::install
    include slurm::db::config
    include slurm::db::service
  }

}

