# == Class slurm::worker::service
#
# This class manages the slurm services
#
# === Parameters
#
# none
#
class slurm::worker::service {

  service {$slurm::slurm_service:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }

}

