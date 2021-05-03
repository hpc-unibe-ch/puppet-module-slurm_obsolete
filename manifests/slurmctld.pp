# @api private
class slurm::slurmctld {

  contain slurm::common::user
  contain slurm::common::install
  contain slurm::common::setup

  Class['slurm::common::user']
  -> Class['slurm::common::install']
  -> Class['slurm::common::setup']
}
