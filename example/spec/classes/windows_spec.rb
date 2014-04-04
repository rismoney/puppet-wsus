require 'spec_helper'

describe 'wsus::windows' do
  context 'host targed for wsus' do
    let(:facts) do {
      :kernel               => 'windows',
      :ise_mock_fqdn        => 'wks.example.com',
      :ise_mock_hostname    => 'wks',
      }
    end
    it { should include_class('wsus::client') }
  end

  context 'hosts not targed for wsus' do
    let(:facts) do {
      :kernel               => 'windows',
      :ise_mock_fqdn        => 'booga.example.com',
      :ise_mock_hostname    => 'booga',
      }
    end
    it { should_not include_class('wsus::client') }
    it { should_not include_class('wsus::server') }
  end

  context 'host is the wsus server' do
    let(:facts) do {
      :kernel               => 'windows',
      :ise_mock_fqdn        => 'wsus.example.com',
      :ise_mock_hostname    => 'wsus',
      }
    end
    it { should include_class('wsus::server') }
  end

end
