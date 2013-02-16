require 'bundler/setup'
require 'omnibus'

overrides = Omnibus::Overrides.overrides

Omnibus.projects("config/projects/*.rb")
Omnibus.software(overrides, "config/software/*.rb")

# We're not building zlib, openssl etc from source, so
# add the known Ruby system lib dependencies to the
# HeathCheck whitelist (so Omnibus won't bomb out
# complaining about links to system libs).
known_libs = [/libz\.so/, /libssl\.so/, /libcrypto\.so/, /libyaml\.so/]

known_libs.each do |lib|
	Omnibus::HealthCheck::WHITELIST_LIBS.push(lib)
end

puts Omnibus::HealthCheck::WHITELIST_LIBS

desc "Print the name and version of all components"
task :versions do
  puts Omnibus::Reports.pretty_version_map('puppet-omnibus')
end
