#
# Cookbook:: freebsd
# Recipe:: portsnap
#
# Copyright:: 2013-2016, Chef Software, Inc.
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

if node['platform'] == 'freebsd'
  portsnap_bin = 'portsnap'
  portsnap_options = '--interactive'

  # Ensure we have a ports tree
  unless File.exist?('/usr/ports/.portsnap.INDEX')
    e = execute "#{portsnap_bin} fetch extract #{portsnap_options}".strip do
      action(node['freebsd']['compiletime_portsnap'] ? :nothing : :run)
    end
    e.run_action(:run) if node['freebsd']['compiletime_portsnap']
  end

  e = execute "#{portsnap_bin} update #{portsnap_options}".strip do
    action(node['freebsd']['compiletime_portsnap'] ? :nothing : :run)
  end
  e.run_action(:run) if node['freebsd']['compiletime_portsnap']
end
