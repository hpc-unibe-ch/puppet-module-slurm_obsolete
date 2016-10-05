# == Class slurm::common
#
# This class installs/configures components common to all slurm nodes
#
# === Parameters
#
# none
#
class slurm::common {

  #### Install packages ####
  package { $slurm::slurm_common_packages:
    ensure => 'present',
  }

  unless $slurm::disable_munge {
    package { $slurm::munge_packages:
      ensure  => 'present',
      require => Yumrepo['epel'],
    }
  }

  unless $slurm::disable_pam {
    package { $slurm::pam_packages:
      ensure => 'present',
    }
  }

  #### Munge Configuration ####

  if $slurm::manage_user_locally {
    # Create MUNGE group/user
    unless $slurm::disable_munge {
      group { $slurm::munge_group:
        ensure => 'present',
        gid    => $slurm::munge_group_id,
      }
      user { $slurm::munge_user:
        ensure     => 'present',
        uid        => $slurm::munge_user_id,
        comment    => 'MUNGE Uid 'N' Gid Emporium',
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
    file {'/etc/munge/munge.key':
      ensure => file,
      source => $slurm::munge_key,
      owner  => $slurm::munge_user,
      group  => $slurm::munge_group,
      mode  => '0400',
    }
  }
 
  #### Slurm Configuration ####

  if $slurm::manage_user_locally {
    #Create SLURM group/user
    group { $slurm::slurm_group:
      ensure => 'present',
      gid    => $slurm::slurm_group_id,
    }
    user { $slurm::slurm_user:
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

  # Create a symbolic link to the shared configuration directory 
  file { '/etc/slurm'
    ensure => link,
    target => $slurm::slurm_conf_dir
    force  => true,
  }

  file { '/var/log/slurm'
    ensure => directory,
    owner  => $slurm::slurm_user,
    group  => $slurm::slurm_group,
    mode   => '0755'
  }

  #### Munge Service ####

  unless $slurm::disable_munge {
    service {'munge':
      ensure => running,
      enable => true,
      hasstatus => true,
      hasrestart => true,
    }
  }

}
