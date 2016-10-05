# == Class slurm::db::install
#
# This class installs the required packages
#
# === Parameters
#
# none
#
class slurm::db::install {

  package { $slurm::slurm_db_packages:
    ensure => 'present',
  }

}

