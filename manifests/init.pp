# == Class: infiniband
#
# See README.md for more details.
class infiniband (
  $packages                     = 'UNSET',
  $with_optional_packages       = true,
  $rdma_service_ensure          = $infiniband::params::service_ensure,
  $rdma_service_enable          = $infiniband::params::service_enable,
  $rdma_service_name            = $infiniband::params::rdma_service_name,
  $rdma_service_has_status      = $infiniband::params::rdma_service_has_status,
  $rdma_service_has_restart     = $infiniband::params::rdma_service_has_restart,
  $ibacm_service_ensure         = $infiniband::params::service_ensure,
  $ibacm_service_enable         = $infiniband::params::service_enable,
  $ibacm_service_name           = $infiniband::params::ibacm_service_name,
  $ibacm_service_has_status     = $infiniband::params::ibacm_service_has_status,
  $ibacm_service_has_restart    = $infiniband::params::ibacm_service_has_restart,
  $rdma_conf_path               = $infiniband::params::rdma_conf_path,
  $ipoib_load                   = 'yes',
  $srp_load                     = 'no',
  $srpt_load                    = 'no',
  $iser_load                    = 'no',
  $rds_load                     = 'no',
  $fixup_mtrr_regs              = 'no',
  $nfsordma_load                = 'yes',
  $nfsordma_port                = 2050,
  $manage_mlx4_core_options     = true,
  $log_num_mtt                  = 'UNSET',
  $log_mtts_per_seg             = '3',
  $interfaces                   = {},
) inherits infiniband::params {

  validate_bool($with_optional_packages)
  validate_re($ipoib_load, ['^yes$', '^no$'])
  validate_re($srp_load, ['^yes$', '^no$'])
  validate_re($iser_load, ['^yes$', '^no$'])
  validate_re($rds_load, ['^yes$', '^no$'])
  validate_re($fixup_mtrr_regs, ['^yes$', '^no$'])
  validate_re($nfsordma_load, ['^yes$', '^no$'])
  validate_bool($manage_mlx4_core_options)
  validate_hash($interfaces)

  if $packages != 'UNSET' {
    validate_array($packages)

    $support_packages = $packages
  } else {
    $support_packages = $with_optional_packages ? {
      true  => flatten([$infiniband::params::base_packages, $infiniband::params::optional_packages]),
      false => $infiniband::params::base_packages,
    }
  }

  include '::infiniband::install'
  include '::infiniband::config'
  include '::infiniband::service'
  include '::infiniband::providers'

  anchor { 'infiniband::start': }
  anchor { 'infiniband::end': }

  Anchor['infiniband::start']->
  Class['infiniband::install']->
  Class['infiniband::config']->
  Class['infiniband::providers']->
  Class['infiniband::service']->
  Anchor['infiniband::end']

}
