require 'spec_helper_acceptance'

describe 'infiniband class' do
  context 'default parameters' do
    it 'should run successfully' do
      pp =<<-EOS
        class { 'infiniband': }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    [
      'libibcm',
      'libibverbs',
      'libibverbs-utils',
      'librdmacm',
      'librdmacm-utils',
      'rdma',
      'dapl',
      'ibacm',
      'ibsim',
      'ibutils',
      'libibmad',
      'libibumad',
      'libipathverbs',
      'libmlx4',
      'libmthca',
      'libnes',
      'rds-tools',
    ].each do |pkg|
      describe package(pkg) do
        it { should be_installed }
      end
    end

    [
      'compat-dapl',
      'infiniband-diags',
      'libibcommon',
      'mstflint',
      'perftest',
      'qperf',
      'srptools',
    ].each do |pkg|
      describe package(pkg) do
        it { should be_installed }
      end
    end

    describe service('rdma') do
      it { should_not be_enabled }
      it { should_not be_running }
    end

    describe service('ibacm') do
      it { should_not be_enabled }
      it { should_not be_running }
    end
  end
end
