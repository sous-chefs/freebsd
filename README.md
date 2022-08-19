# freebsd Cookbook

[![Cookbook Version](https://img.shields.io/cookbook/v/freebsd.svg)](https://supermarket.chef.io/cookbooks/freebsd)
[![CI State](https://github.com/sous-chefs/freebsd/workflows/ci/badge.svg)](https://github.com/sous-chefs/freebsd/actions?query=workflow%3Aci)
[![OpenCollective](https://opencollective.com/sous-chefs/backers/badge.svg)](#backers)
[![OpenCollective](https://opencollective.com/sous-chefs/sponsors/badge.svg)](#sponsors)
[![License](https://img.shields.io/badge/License-Apache%202.0-green.svg)](https://opensource.org/licenses/Apache-2.0)

Sets up ports and pkgng on FreeBSD systems

## Maintainers

This cookbook is maintained by the Sous Chefs. The Sous Chefs are a community of Chef cookbook maintainers working together to maintain important cookbooks. If you’d like to know more please visit [sous-chefs.org](https://sous-chefs.org/) or come chat with us on the Chef Community Slack in [#sous-chefs](https://chefcommunity.slack.com/messages/C2V7B88SF).

## Requirements

### Platforms

- FreeBSD

### Chef

- Chef 15.3+

### Cookbooks

- none

## Attributes

Attribute                                 | Default | Description
----------------------------------------- | ------- | ------------------------------------------
`node['freebsd']['compiletime_portsnap']` | `false` | Execute portsnap resources at compile time

## Supported Versions

This cookbook will support stable and release [versions](https://www.freebsd.org/security/index.html#sup) of the FreeBSD Platform. More information on this subject can be found at [issue23](https://github.com/chef-cookbooks/freebsd/issues/23).

## Usage

### freebsd::portsnap

This recipe ensures the Ports Collection collection is fully up to date.

This recipe should appear first in the run list of FreeBSD nodes to ensure that the package cache is up to date before managing any `package` resources with Chef.

## Resources

### port_options

Provides an easy way to set port options from within a cookbook.

It can be used in two different ways:

- template-based: specifying a source will write it to the correct destination with no change;
- options hash: if a options hash is passed instead, it will be merged on top of default and current options, and the result will be written back.

Note that the options hash take simple options names as keys and a boolean as value; when saving to file, this is converted to the format that FreeBSD ports expect:

Option Key Name | Option Value | Options File
--------------- | ------------ | -------------------
APACHE          | true         | WITH_APACHE=true
APACHE          | false        | WITHOUT_APACHE=true

#### Actions

Action | Description                                                 | Default
------ | ----------------------------------------------------------- | -------
create | create the port options file according to the given options | Yes

#### Properties

Property | Description
-------- | --------------------------------------------------------------------------------------------------------------
name     | The name of the port whose options file you want to manipulate;
source   | if the property is set, it will be used to look up a template, which will then be saved as a port options file
options  | a hash with the option name as the key, and a boolean as value.

#### Examples

```ruby
# freebsd-php5-options will be written out as /var/db/ports/php5/options
freebsd_port_options 'php5' do
  source 'freebsd-php5-options.erb'
  action :create
end

# Default options will be read from /usr/ports/lang/php5;
# current options from /var/db/ports/php5/options (if exists);
# the APACHE options will be set to true, the others will be unchanged
freebsd_port_options 'php5' do
  options 'APACHE' => true
  action :create
end
```

## Contributors

This project exists thanks to all the people who [contribute.](https://opencollective.com/sous-chefs/contributors.svg?width=890&button=false)

### Backers

Thank you to all our backers!

![https://opencollective.com/sous-chefs#backers](https://opencollective.com/sous-chefs/backers.svg?width=600&avatarHeight=40)

### Sponsors

Support this project by becoming a sponsor. Your logo will show up here with a link to your website.

![https://opencollective.com/sous-chefs/sponsor/0/website](https://opencollective.com/sous-chefs/sponsor/0/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/1/website](https://opencollective.com/sous-chefs/sponsor/1/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/2/website](https://opencollective.com/sous-chefs/sponsor/2/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/3/website](https://opencollective.com/sous-chefs/sponsor/3/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/4/website](https://opencollective.com/sous-chefs/sponsor/4/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/5/website](https://opencollective.com/sous-chefs/sponsor/5/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/6/website](https://opencollective.com/sous-chefs/sponsor/6/avatar.svg?avatarHeight=100)
![https://opencollective.com/sous-chefs/sponsor/7/website](https://opencollective.com/sous-chefs/sponsor/7/avatar.svg?avatarHeight=100)
