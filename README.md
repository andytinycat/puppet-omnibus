Omnibus Puppet package project
==============================

This is an Omnibus project that will build a "monolithic" OS package for Puppet. It installs
a source-built Ruby in /opt/puppet-omnibus, then installs all the gems required for Puppet
to work into this Ruby. This means it leaves the system-supplied Ruby completely untouched,
along with any other Rubies you might happen to have installed.

Warning!
========

Right now, this package isn't completely sorted, as it's in the process of moving from
Opscode's Omnibus project to fpm-cookery. Check back in a few days.

Why create a monolithic Puppet package?
---------------------------------------

The goal was to create a Puppet package that could be dropped onto a system at the end of the OS
install and immediately begin to manage the system in its entirety, which includes installing
and managing the Ruby versions on the machine. Keeping Puppet separate from Rubies used to
run applications means this is possible (and it also means you can't break your config management
agent by mucking around with Ruby).

What are Omnibus packages?
--------------------------

[Omnibus](https://github.com/opscode/omnibus-ruby) is an OS packaging system built in Ruby, written
by the Opscode folks. It was created to build monolithic packages for Chef (which requires Ruby
as well). Rather than re-inventing the packaging wheel, it makes use of Jordan Sissel's [fpm](https://github.com/jordansissel/fpm)
to build the final package.

The first version of this project used Opscode's tool, but they don't seem to take pull requests,
so I enhanced bernd's superb [fpm-cookery](https://github.com/bernd/fpm-cookery) to create Omnibus
packages, and switched this project to use it.

Runtime OS package dependencies
-------------------------------

Obviously some components of Ruby/Puppet/Facter have library dependencies. Opscode take the approach of
building *any* binary component from source and having it inside the package. I think this is
wasteful if you only have a few OS dependencies - instead, the final package this project
builds depends on the OS packages, so apt will automatically pull them in when you install
the package.

Included gems
-------------

The following gems are built into the Ruby that Puppet will run from:
- facter
- puppet
- hiera
- json-pure
- puppet
- ruby-augeas
- ruby-shadow
- aws-sdk
- fog

I build in aws-sdk and fog because some of my custom Puppet types make use of AWS APIs. Note that
if you need any gems for your custom types, you will have to build them into the Omnibus package
(or use the `gem` command at `/opt/puppet-omnibus/embedded/bin/gem` to install another gem
into the omnibus Ruby - but that's not very CM-friendly!)

How do I build the package?
---------------------------

First you need to clone the repo and do a `bundle install` to get fpm-cookery.

    $ git clone https://github.com/andytinycat/puppet-omnibus
    $ bundle install

Now use fpm-cookery to build the package:

    $ bundle exec fpm-cook recipes/puppet-omnibus.rb

The final package will be at:

    recipes/puppet-omnibus/pkg

You might want to update the maintainer, revision and vendor in puppet-omnibus.rb.

Testing
-------

This can be considered beta, as it's only been tested on Ubuntu 12.04. However, it should
work on any distribution, except the package dependency names will need to be changed. It's
been in production for a few months at my current gig without any reported problems.

Credits
-------

Credit for the Omnibus idea goes to the [Opscode](www.opscode.com) and [Sensu](http://sensuapp.org/)
folks. Credit for coming up with the idea of packaging Puppet like Chef belongs to my colleague
[lloydpick](https://github.com/lloydpick). Thanks to [bernd](https://github.com/bernd) for the
awesome [fpm-cookery](https://github.com/bernd/fpm-cookery) and for taking my PRs.
