# == Class slurm::master::install
#
# This class installs the required packages
#
# === Parameters
#
# none
#
class slurm::master::install {

  package { $slurm::slurm_master_packages:
    ensure          => 'present',
    install_options => { '--disablerepo' => 'epel' },
  }

}

