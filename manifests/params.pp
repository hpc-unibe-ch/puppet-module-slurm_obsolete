# == Class slurm::params
#
# This class is meant to be called from slurm
# It sets the variables according to the platform used
#
class slurm::params {
  $is_slurm_master     = false
  $is_slurm_worker     = true
  $is_slurm_db         = false
  $disable_munge       = false
  $disable_pam         = false
  $manage_user_locally = true
  $munge_key           = undef
  $slurm_conf_dir      = undef

  case $::operatingsystem {
    /^(RedHat|CentOS)$/: {
      $munge_packages = [ 'munge', 'munge-libs', 'munge-devel', 'slurm-munge' ]
      $slurm_common_packages = [ 'slurm', 'slurm-devel', 'slurm-plugins', 'slurm-perlapi', 'slurm-plugins', 'slurm-sjobexit', 'slurm-sjstat', 'slurm-torque' ]
      $pam_packages   = [ 'slurm-pam_slurm' ]
      $slurm_db_packages = [ 'slurm', 'slurm-devel', 'slurm-plugins', 'slurm-slurmdbd', 'slurm-sql' ]
      $munge_service  = 'munge'
      $munge_group    = 'munge'
      $munge_group_id = 991
      $munge_user     = $munge_group
      $munge_user_id  = $munge_group_id
      $slurm_group    = 'slurm'
      $slurm_group_id = 992
      $slurm_user     = $slurm_group
      $slurm_user_id  = $slurm_group_id

      case $::operatingsystemmajrelease {
        '7': {
          $config_dir           = '/etc/slurm'
          $slurm_service        = 'slurmd'
          $slurm_master_service = 'slurmctld'
          $slurm_db_service     = 'slurmdbd'
        }
        default: {
          fail('This major release is not supported')
        }
      }
    }
    default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
