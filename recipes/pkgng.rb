#
# Cookbook Name:: freebsd
# Recipe:: pkgng
#
# Copyright 2014, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'freebsd::portsnap'

#
# Install and configure PKGNG
#
#   https://www.freebsd.org/doc/handbook/pkgng-intro.html
#
#
execute 'make UPGRADEPKG=1 -C /usr/ports/ports-mgmt/pkg install clean' do
  not_if 'pkg -N'
end

# To ensure that the FreeBSD Ports Collection registers new software with
# pkg, and not the traditional packages format, FreeBSD versions earlier
# than 10.X require this line in `/etc/make.conf`.
#
# Chef also uses this variable to determine if it should use the PKGNG
# provider for FreeBSD's package resource:
#
#   https://github.com/opscode/chef/blob/11.16.4/lib/chef/resource/freebsd_package.rb#L57-L75
#
if File.exist?('/etc/make.conf')

  ruby_block 'Ensure ports registers new software with PKGNG' do
    block do
      file = Chef::Util::FileEdit.new('/etc/make.conf')
      file.insert_line_if_no_match(/^WITH_PKGNG/, 'WITH_PKGNG=yes')
      file.write_file
    end
  end

else

  file '/etc/make.conf' do
    content <<-EOH
WITH_PKGNG=yes
    EOH
    owner 'root'
    group 'wheel'
    mode '0644'
  end

end

# Upgrade existing package database
execute 'pkg2ng'

#
# Enable the default PKGNG repo. Taken from:
#
#   https://www.freebsd.org/security/advisories/FreeBSD-EN-14:03.pkg.asc
#
directory '/etc/pkg' do
  owner 'root'
  group 'wheel'
  mode '0755'
end

file '/etc/pkg/FreeBSD.conf' do
  content <<-EOH
FreeBSD: {
  url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest",
  mirror_type: "SRV",
  enabled: yes
}
  EOH
  owner 'root'
  group 'wheel'
  mode '0644'
  action :create_if_missing # Don't modify the file if it exists
end

execute 'pkg update'
