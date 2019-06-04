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
    group  => 'root',
    mode   => '0644',
  }

  file { '/etc/sysconfig/slurm':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => file('slurm/slurm_sysconfig'),
  }
}
