require 'spec_helper'

describe 'freebsd::portsnap' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  let(:portsnap_bin) { 'portsnap' }
  let(:portsnap_options) { '--interactive' }

  it 'fetches and extracts with the default portsnap' do
    expect(chef_run).to run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
  end

  it 'updates the extracted ports tree' do
    expect(chef_run).to run_execute("#{portsnap_bin} update #{portsnap_options}")
  end

  context 'the ports tree is already extracted' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/usr/ports/.portsnap.INDEX').and_return(true)
    end

    it 'does not fetch and extract' do
      expect(chef_run).to_not run_execute("#{portsnap_bin} fetch extract #{portsnap_options}")
    end
  end

  context 'FreeBSD 9' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'freebsd', version: '9.2')
        .converge(described_recipe)
    end
    let(:portsnap_bin) { File.join(Chef::Config[:file_cache_path], 'portsnap') }

    it 'generates a patched portsnap bin' do
      expect(chef_run).to run_script('create non-interactive portsnap').with(interpreter: 'sh')
    end

    it 'fetches and extracts with the patched portsnap bin' do
      expect(chef_run).to run_execute("#{portsnap_bin} fetch extract")
    end
  end
end
