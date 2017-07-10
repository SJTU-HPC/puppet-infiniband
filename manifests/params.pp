# The infiniband default configuration settings.
class infiniband::params {

  case $::osfamily {
    'RedHat': {
      if versioncmp($::operatingsystemmajrelease, '7') == 0 {
        $base_packages = [
          'dapl',
          'ibacm',
          'ibutils',
          'libcxgb3',
          'libcxgb4',
          'libibcm',
          'libibmad',
          'libibumad',
          'libibverbs',
          'libibverbs-utils',
          'libipathverbs',
          'libmlx4',
          'libmlx5',
          'libmthca',
          'libnes',
          'librdmacm',
          'librdmacm-utils',
          'rdma',
        ]

        $optional_packages = [
          'compat-dapl',
          'infiniband-diags',
          'libibcommon',
          'mstflint',
          'perftest',
          'qperf',
          'srptools',
        ]
      } elsif versioncmp($::operatingsystemrelease , '6.6') >= 0 {
        $base_packages = [
          'dapl',
          'ibacm',
          'ibsim',
          'ibutils',
          'libcxgb3',
          'libibcm',
          'libibmad',
          'libibumad',
          'libibverbs',
          'libibverbs-utils',
          'libipathverbs',
          'libmlx4',
          'libmlx5',
          'libmthca',
          'libnes',
          'librdmacm',
          'librdmacm-utils',
          'rdma',
          'rds-tools',
        ]

        $optional_packages = [
          'compat-dapl',
          'infiniband-diags',
          'libibcommon',
          'libocrdma',
          'mstflint',
          'perftest',
          'qperf',
          'srptools',
        ]
      } elsif versioncmp($::operatingsystemmajrelease, '6') == 0 {
        $base_packages = [
          'dapl',
          'ibacm',
          'ibsim',
          'ibutils',
          'libcxgb3',
          'libibcm',
          'libibmad',
          'libibumad',
          'libibverbs',
          'libibverbs-utils',
          'libipathverbs',
          'libmlx4',
          'libmthca',
          'libnes',
          'librdmacm',
          'librdmacm-utils',
          'rdma',
          'rds-tools',
        ]

        $optional_packages = [
          'compat-dapl',
          'infiniband-diags',
          'libibcommon',
          'mstflint',
          'perftest',
          'qperf',
          'srptools',
        ]
      } else {
        fail("Unsupported operatingsystemmajrelease: ${::operatingsystemmajrelease}, module ${module_name} only supports osfamily RedHat 6 and 7")
      }

      $rdma_service_name          = 'rdma'
      $rdma_service_has_status    = true
      $rdma_service_has_restart   = true
      $ibacm_service_name         = 'ibacm'
      $ibacm_service_has_status   = true
      $ibacm_service_has_restart  = true
      $rdma_conf_path             = '/etc/rdma/rdma.conf'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only supports osfamily RedHat")
    }
  }

  # Set default service states based on has_infiniband fact value
  case $::has_infiniband {
    true : {
      $service_ensure = 'running'
      $service_enable = true
    }

    default : {
      $service_ensure = 'stopped'
      $service_enable = false
    }
  }

}
