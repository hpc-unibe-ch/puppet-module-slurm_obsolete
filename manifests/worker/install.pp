# == Class slurm::worker::install
#
# This class installs the required packages
#
# === Parameters
#
# none
#
class slurm::worker::install {

  package { $slurm::slurm_worker_packages:
    ensure          => 'present',
    install_options => '--nogpgcheck',
  }

}

