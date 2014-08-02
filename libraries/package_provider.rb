#
# Cookbook Name:: freebsd
# Libraries:: package_provider
#
# Copyright 2012, ZephirWorks
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

chef_version = ::Chef::VERSION.split('.')[0..2].join('.').to_f

if chef_version < 11.14
  require 'chef/provider/package/freebsd'
else
  require 'chef/provider/package/freebsd/base'
end

# Ugly hacks to support ugly monkey patching.
# Somebody should find a better way to support FreeBSD < 8.2
if chef_version < 11.14
  class Chef
    class Provider
      class Package
        #
        class FreeBSD
          alias_method :original_initialize, :initialize

          def initialize(*args)
            original_initialize(*args)

            if node.platform == 'freebsd' && node.platform_version.to_f < 8.2 &&
                @new_resource.source != 'ports'
              Chef::Log.info "Packages for FreeBSD < 8.2 are gone, forcing #{@new_resource.name} to install from ports (was: #{@new_resource.source.inspect})"
              @new_resource.source('ports')
            end
          end
        end
      end
    end
  end
else
  class Chef
    class Provider
      class Package
        #
        module FreeBSD
          alias_method :original_initialize, :initialize

          def initialize(*args)
            original_initialize(*args)

            if node.platform == 'freebsd' && node.platform_version.to_f < 8.2 &&
                @new_resource.source != 'ports'
              Chef::Log.info "Packages for FreeBSD < 8.2 are gone, forcing #{@new_resource.name} to install from ports (was: #{@new_resource.source.inspect})"
              @new_resource.source('ports')
            end
          end
        end
      end
    end
  end
end
