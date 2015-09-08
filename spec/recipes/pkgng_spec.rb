require 'spec_helper'

describe 'freebsd::pkgng' do
  let(:chef_run) { ChefSpec::ServerRunner.converge(described_recipe) }
  before { stub_command('pkg -N').and_return(false) }

  it 'installs PKGNG' do
    expect(chef_run).to run_execute('make UPGRADEPKG=1 -C /usr/ports/ports-mgmt/pkg install clean')
  end

  context 'PKGNG is already installed' do
    before { stub_command('pkg -N').and_return(true) }

    it 'does not install PKGNG' do
      expect(chef_run).to_not run_execute('make UPGRADEPKG=1 -C /usr/ports/ports-mgmt/pkg install clean')
    end
  end

  context '/etc/make.conf exists' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/make.conf').and_return(true)
    end

    it 'ensures WITH_PKGNG is set to yes' do
      expect(chef_run).to run_ruby_block('Ensure ports registers new software with PKGNG')
    end
  end

  context '/etc/make.conf does not exist' do
    before do
      allow(File).to receive(:exist?).and_call_original
      allow(File).to receive(:exist?).with('/etc/make.conf').and_return(false)
    end

    it 'creates /etc/make.conf' do
      expect(chef_run).to render_file('/etc/make.conf').with_content('WITH_PKGNG=yes')
    end
  end

  it 'creates the pkg config directory' do
    expect(chef_run).to create_directory('/etc/pkg').with(
      owner: 'root',
      group: 'wheel',
      mode: '0755'
    )
  end

  it 'creates configuration for the official package repository' do
    expect(chef_run).to create_file_if_missing('/etc/pkg/FreeBSD.conf').with(
      owner: 'root',
      group: 'wheel',
      mode: '0644'
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
    expect(chef_run).to run_execute('pkg update')
  end
end
