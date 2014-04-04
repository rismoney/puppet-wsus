require 'spec_helper'

describe 'wsus::client' do
  context 'configure windows update service on wks' do
    let(:facts) do {
      :kernel               => 'windows',
      :ise_mock_fqdn        => 'wks.example.com',
      :ise_mock_hostname    => 'wks',
      }
    end
    it { should contain_registry_value('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\TargetGroupEnabled') }
    it { should contain_registry_value('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\TargetGroup') }
    it { should contain_registry_value('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\WUServer') }
    it { should contain_registry_value('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\WUStatusServer') }
    it { should contain_registry_value('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\UseWUServer') }
    it { should contain_registry_value('HKEY_LOCAL_MACHINE\Software\Policies\Microsoft\Windows\WindowsUpdate\AU\NoAutoUpdate') }
    it { should contain_file('wsus-register.ps1') }
    it { should contain_exec('wsus-register') }
    it { should contain_file('wsus-enforce.ps1') }
  end
end
