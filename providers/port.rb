#
# Cookbook Name:: freebsd
# Provider:: port
#
# Copyright 2016, Alexander Zubkov
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

use_inline_resources

require 'chef/mixin/shell_out'

include Chef::Mixin::ShellOut

action :install do
  unless package_installed?
    freebsd_port_options new_resource.name do
      options new_resource.options
      not_if { new_resource.options.nil? }
    end
    package new_resource.name do
      source 'ports'
    end
  end
end

action :remove do
  package new_resource.name do
    source 'ports'
    action :remove
    only_if { package_installed? }
  end
end

protected

def package_installed?
  pkg_info = shell_out!("pkg info \"#{new_resource.name}\"", env: nil, returns: [0, 70])
  pkg_info.stderr.match('pkg: No package\(s\) matching').nil?
end
