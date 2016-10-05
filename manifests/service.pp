# == Class slurm::service
#
# This class manages the slurm services
#
# === Parameters
#
# none
#
class slurm::service {

  unless $slurm::disable_munge {
    service {'munge':
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
    }
  }

}

