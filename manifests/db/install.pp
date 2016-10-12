# == Class slurm::db::install
#
# This class installs the required packages
#
# === Parameters
#
# none
#
class slurm::db::install {

  package { $slurm::slurm_sql_packages:
    ensure          => 'present',
    install_options => '--nogpgcheck',
  }

}

