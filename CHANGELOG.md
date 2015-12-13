# freebsd cookbook CHANGELOG
This file is used to list changes made in each version of the freebsd cookbook.

## v0.5.0 (2015-12-13)
- Only execute the cookbooks when running on FreeBSD so they can be safely included in base roles where they might run on Linux or Windows hosts

## v0.4.0 (2015-10-20)
- Added a new option to execute the portsnap resources at compile time: `node['freebsd']['compiletime_portsnap']`
- Updated the supported FreeBSD releases to match those supported by the Chef Client (9/10 only)
- Significantly expanded Chefspec testing
- Added source_url and issues_url to the metadata
- Updated the gitignore file
- Test on the latest Freebsd boxes in Test Kitchen
- Added chefignore file
- Added Chef standard rubocop config
- Updated Travis CI testing to use the ChefDK for up to date deps
- Updated Gemfile with the latest testing deps
- Updated testing and contributing docs
- Added maintainers.md and maintainers.toml files
- Added travis and cookbook version badges to the readme
- Resolved Rubocop warnings

## v0.3.0 (2014-10-30)
- Removing package provider monkey patch
- Dropping FreeBSD 8.2 support

## v0.2.1 (2014-10-23)
- Don't install PKGNG on 9 if it already exists

## v0.2.0 (2014-10-22)
- Add a recipe to install and configure PKGNG
- Level up ChefSpec and ServerSpec coverage

## v0.1.10 (2014-10-06)
- Update method used for non-interactive portsnap on FreeBSD 10

## v0.1.9 (2014-08-02)
- Updating to support both 11.12.8 and 11.4.2

## v0.1.8 (2014-08-02)
- Reverting changes made in v0.1.6

## v0.1.6 (2014-08-01)
- Update provider to match Chef-Client 11.14.2 changes

## v0.1.2 (2014-04-09)
- [COOK-4454] Added FreeBSD 10 to test harness

## v0.1.2 (2014-02-25)
[COOK-3933] - Add a recipe for ensuring the Ports Collection is up-to-date

## v0.1.0
- [COOK-2568]: FreeBSD cookbook throws Error in runtime

## v0.0.6
- [COOK-1605] - `freebsd_port_options` always notifies

## v0.0.4
- [COOK-1430] - resolve foodcritic warnings; LWRP now defines default action

## v0.0.2
- [COOK-1084] - fix older version building from ports

## v0.0.1
- [COOK-1074] - initial release
