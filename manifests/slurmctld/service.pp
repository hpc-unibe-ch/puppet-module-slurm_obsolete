# @api private
class slurm::slurmctld::service {

  file { '/etc/sysconfig/slurmctld':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('slurm/sysconfig/slurmctld.erb'),
    notify  => Service['slurmctld'],
  }

  if ! empty($slurm::slurmctld_service_limits) {
    systemd::service_limits { 'slurmctld.service':
      limits          => $slurm::sslurmctld_service_limits,
      restart_service => false,
      notify          => Service['slurmctld'],
    }
  }

  service { 'slurmctld':
    ensure     => $slurm::slurmctld_service_ensure,
    enable     => $slurm::slurmctld_service_enable,
    hasstatus  => true,
    hasrestart => true,
  }

  exec { 'scontrol reconfig':
    path        => '/usr/bin:/bin:/usr/sbin:/sbin',
    refreshonly => true,
    require     => Service['slurmctld'],
  }
}
