# == Class slurm::db::config
#
# This class configures
#
# === Parameters
#
# none
#
class slurm::db::config {

  file { '/var/log/slurm/slurmdbd.log':
    ensure => 'file',
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0644',
  }

}

