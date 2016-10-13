# == Class slurm::worker::config
#
# This class configures
#
# === Parameters
#
# none
#
class slurm::worker::config {

  file { '/var/spool/slurmd':
    ensure => directory,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0755',
  }

  # Create the slurmd logfile
  file { '/var/log/slurm/slurmd.log':
    ensure => file,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0644',
  }

}
