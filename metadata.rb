name 'freebsd'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Handles FreeBSD-specific features'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.3.0'

supports 'freebsd'

source_url 'https://github.com/chef-cookbooks/freebsd' if respond_to?(:source_url)
issues_url 'https://github.com/chef-cookbooks/freebsd/issues' if respond_to?(:issues_url)
