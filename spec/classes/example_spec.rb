require 'spec_helper'

describe 'slurm' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "slurm class without any parameters on #{osfamily}" do
          let(:params) {{ }}

          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('slurm::params') }
          it { is_expected.to contain_class('slurm::install').that_comes_before('slurm::config') }
          it { is_expected.to contain_class('slurm::config') }
          it { is_expected.to contain_class('slurm::service').that_subscribes_to('slurm::config') }

          it { is_expected.to contain_service('slurm') }
          it { is_expected.to contain_package('slurm').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'slurm class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { is_expected.to contain_package('slurm') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end

