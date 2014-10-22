require 'spec_helper'

describe 'freebsd::pkgng' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }

  before { stub_command('make -V WITH_PKGNG | grep yes').and_return(false) }

  context 'FreeBSD 9' do
    let(:chef_run) do
      ChefSpec::ServerRunner.new(platform: 'freebsd', version: '9.2')
        .converge(described_recipe)
    end

    it 'installs pkgng' do
      expect(chef_run).to run_execute('install pkgng')
    end
  end

  it 'creates the pkg config directory' do
    expect(chef_run).to create_directory('/etc/pkg').with(
      owner: 'root',
      group: 'wheel',
      mode: '0755',
    )
  end

  it 'creates configuration for the official package repository' do
    expect(chef_run).to create_file_if_missing('/etc/pkg/FreeBSD.conf').with(
      owner: 'root',
      group: 'wheel',
      mode: '0644',
    )

    expect(chef_run).to render_file('/etc/pkg/FreeBSD.conf').with_content(
      <<-EOH
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest",
  mirror_type: "SRV",
  enabled: yes
}
      EOH
    )
  end

  it 'notifies pkg to update' do
    expect(chef_run.file('/etc/pkg/FreeBSD.conf')).to notify('execute[pkg update]').to(:run).immediately
  end
end
