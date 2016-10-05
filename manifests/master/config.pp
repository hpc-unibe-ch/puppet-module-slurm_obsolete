# == Class slurm::master::config
#
# This class configures
#
# === Parameters
#
# none
#
class slurm::master::config {

  file { '/var/spool/slurmctld'
    ensure => directory,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0755'   
  }

  # Create the slurmctld logfile
  file { '/var/log/slurm/slurmctld.log'
    ensure => file,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0644'
  }

  # Create default accounting files
  file { '/var/log/slurm/slurm_jobacct.log'
    ensure => file,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0644'
  }

  file { '/var/log/slurm/slurm_jobcomp.log'
    ensure => file,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0644'
  }

}
