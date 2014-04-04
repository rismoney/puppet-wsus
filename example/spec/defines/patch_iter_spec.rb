# vim: set ts=2 sw=2 ai et:
require 'spec_helper'

describe 'wsus::patch_iter' do
  context "when title  => 'samplegroup1'" do
    let(:title) { 'samplegroup1' }
    let(:facts) do {
      :kernel               => 'windows',
      :ise_mock_fqdn        => 'wsus.example.com',
      :ise_mock_hostname    => 'wsus',
      }
    end
    it { should contain_wsus__patch('kb2868626-samplegroup1') }
  end
end
