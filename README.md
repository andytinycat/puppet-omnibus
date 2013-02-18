Omnibus Puppet package project
==============================

This is an Omnibus project that will build a "monolithic" OS package for Puppet. It installs
a source-built Ruby in /opt/puppet-omnibus, then installs all the gems required for Puppet
to work into this Ruby. This means it leaves the system-supplied Ruby completely untouched,
along with any other Rubies you might happen to have installed.

Why create a monolithic Puppet package?
---------------------------------------

The goal was to create a Puppet package that could be dropped onto a system at the end of the OS
install and immediately begin to manage the system in its entirety, which includes installing
and managing the Ruby versions on the machine. Keeping Puppet separate from Rubies used to
run applications means this is possible (and it also means you can't break your config management
agent by mucking around with Ruby).

What is Omnibus?
----------------

[Omnibus](https://github.com/opscode/omnibus-ruby) is an OS packaging system built in Ruby, written
by the Opscode folks. It was created to build monolithic packages for Chef (which requires Ruby
as well). Rather than re-inventing the packaging wheel, it makes use of Jordan Sissel's [fpm](https://github.com/jordansissel/fpm)
to build the final package.

Runtime OS package dependencies
-------------------------------

Obviously some components of Ruby/Puppet/Facter have library dependencies. Opscode take the approach of
building *any* binary component from source and having it inside the package. I think this is
wasteful if you only have a few OS dependencies - instead, the final package this project
builds depends on the OS packages, so apt will automatically pull them in when you install
the package.

How do I build the package?
---------------------------

First you need to clone the repo and do a `bundle install` to get Omnibus.

    $ git clone https://github.com/andytinycat/puppet-omnibus
    $ bundle install

Omnibus makes use of Rake to provide build tasks. To see all the available build tasks:

    $ bundle exec rake -T
    rake clean                                         # Remove any temporary products.
    rake clobber                                       # Remove any generated file.
    rake projects:puppet-omnibus                       # package puppet-omnibus
    rake projects:puppet-omnibus:deb                   # package puppet-omnibus into a deb
    rake projects:puppet-omnibus:health_check          # run the health check on the puppet-omnibus install path
    rake projects:puppet-omnibus:software:facter       # fetch and build facter for puppet-omnibus
    rake projects:puppet-omnibus:software:hiera        # fetch and build hiera for puppet-omnibus
    rake projects:puppet-omnibus:software:json_pure    # fetch and build json_pure for puppet-omnibus
    rake projects:puppet-omnibus:software:preparation  # fetch and build preparation for puppet-omnibus
    rake projects:puppet-omnibus:software:puppet       # fetch and build puppet for puppet-omnibus
    rake projects:puppet-omnibus:software:ruby         # fetch and build ruby for puppet-omnibus
    rake projects:puppet-omnibus:software:ruby-augeas  # fetch and build ruby-augeas for puppet-omnibus
    rake projects:puppet-omnibus:software:ruby-shadow  # fetch and build ruby-shadow for puppet-omnibus
    rake versions                                      # Print the name and version of all components

To build the OS package, simply run the top-level task:

    $ bundle exec rake projects:puppet-omnibus

At the end of the build, the package will be in pkg/ directory inside the project.

Testing
-------

This can be considered extremely alpha, as it's only been tested on Ubuntu 12.04. However, it should
work on any distribution, except the package dependency names will need to be changed.

Forked version of omnibus-ruby
------------------------------

The Gemfile uses my fork of omnibus-ruby. The Opscode repo one doesn't let you set these parameters on the final package:
- maintainer
- URL
- Conflicts:
- description

Also it doesn't provide a way to supply extra paths to FPM to package; we need this so we can package the init script for
Puppet inside the package.

The fork adds these features (and there's a pull request outstanding against opscode/omnibus-ruby).

Todo
----

- make use of Facter to figure out the distribution and platform, and rewrite the -dev and runtime
  dependencies appropriately
- figure out how to make `rake versions` work (right now it seems to be broken inside Omnibus)
