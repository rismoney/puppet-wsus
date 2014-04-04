# vim: set ts=2 sw=2 ai et:
require 'spec_helper'

describe 'wsus::patch' do
  context "when title  => 'kb2868626-samplegroup1'" do
    let(:title) { 'kb2868626-samplegroup1' }
    let(:facts) do {
      :kernel               => 'windows',
      :ise_mock_fqdn        => 'wsus.example.com',
      :ise_mock_hostname    => 'wsus',
      }
    end
    it { should contain_wsuspatchstatus('kb2868626-samplegroup1').with('ensure' => 'present') }
  end
end
