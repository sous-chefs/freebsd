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
execute 'install pkgng' do
  command <<-EOH
echo "WITH_PKGNG=yes" >> /etc/make.conf
make UPGRADEPKG=1 -C /usr/ports/ports-mgmt/pkg install clean
  EOH
  # It was not until FreeBSD version 1000017 that pkgng became
  # the default binary package manager. See '/usr/ports/Mk/bsd.port.mk'.
  not_if { node['os_version'].to_i >= 1_000_017 }
  not_if 'make -V WITH_PKGNG | grep yes'
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
  action :create_if_missing
  notifies :run, 'execute[pkg update]', :immediately
end

execute 'pkg update' do
  action :nothing
end
