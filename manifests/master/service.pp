# == Class slurm::master::service
#
# This class manages the slurm services
#
# === Parameters
#
# none
#
class slurm::master::service {

  service {$slurm::slurm_master_service:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }

}

