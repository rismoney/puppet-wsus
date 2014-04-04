require 'spec_helper'

describe 'wsus::server' do
  context 'create samplegroup1 on ix-pm01' do
    let(:facts) do {
      :kernel               => 'windows',
      :ise_mock_fqdn        => 'wsus.example.com',
      :ise_mock_hostname    => 'wsus',
      }
    end
    it { should contain_wsusgroup('samplegroup1') }
    it { should contain_wsusgroup('samplegroup2') }
    it { should contain_file('Fetch-WSUS.ps1') }
    it { should contain_wsus__patch_iter('samplegroup1') }
  end
end
