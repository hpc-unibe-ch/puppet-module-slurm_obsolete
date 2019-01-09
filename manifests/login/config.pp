# == Class slurm::login::config
#
# This class installs the required packages
#
# === Parameters
#
# none
#
class slurm::login::config {

  unless $slurm::disable_munge {
    package { $slurm::munge_packages:
      ensure          => 'present',
      install_options => '--nogpgcheck',
      before          => File['munge key'],
      #require        => Yumrepo['epel'],
    }
  }

  #### Munge Configuration ####

  if $slurm::manage_user_locally {
    # Create MUNGE group/user
    unless $slurm::disable_munge {
      group { 'munge':
        name   => $slurm::munge_group,
        ensure => 'present',
        gid    => $slurm::munge_group_id,
      }
      user { 'munge':
        name       => $slurm::munge_user,
        ensure     => 'present',
        uid        => $slurm::munge_user_id,
        comment    => "MUNGE Uid 'N' Gid Emporium",
        gid        => $slurm::munge_group,
        managehome => true,
        home       => '/var/lib/munge',
        shell      => '/sbin/nologin',
        require    => Group[$slurm::munge_group],
      }
    }
  }

  # Munge key
  unless $slurm::disable_munge {
    file {'munge key':
      ensure  => 'file',
      path    => '/etc/munge/munge.key',
      content => file($slurm::munge_key),
      owner   => $slurm::munge_user,
      group   => $slurm::munge_group,
      mode    => '0400',
      require => Package['munge'],
    }
  }

  #### Slurm Configuration ####

  if $slurm::manage_user_locally {
    #Create SLURM group/user
    group { 'slurm':
      name   => $slurm::slurm_group,
      ensure => 'present',
      gid    => $slurm::slurm_group_id,
    }
    user { 'slurm':
      name       => $slurm::slurm_user,
      ensure     => 'present',
      uid        => $slurm::slurm_user_id,
      comment    => 'SLURM workload manager',
      gid        => $slurm::slurm_group,
      managehome => true,
      home       => '/var/lib/slurm',
      shell      => '/bin/bash',
      require    => Group[$slurm::slurm_group],
    }
  }

  #### Munge Service ####

  unless $slurm::disable_munge {
    service {'munge':
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => File['munge key'],
    }
  }

}

