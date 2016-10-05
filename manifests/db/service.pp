# == Class slurm::db::service
#
# This class manages the slurm services
#
# === Parameters
#
# none
#
class slurm::db::service {

  service {$slurm::slurm_db_service:
    ensure => running,
    enable => true,
    hasstatus => true,
    hasrestart => true,
  }

}

