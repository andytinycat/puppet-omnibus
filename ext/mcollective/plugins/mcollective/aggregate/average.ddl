metadata  :name        => "average",
          :description => "Displays the average of a set of numeric values",
          :author      => "Pieter Loubser <pieter.loubser@puppetlabs.com>",
          :license     => "ASL 2.0",
          :version     => "1.0",
          :url         => "http://projects.puppetlabs.com/projects/mcollective-plugins/wiki",
          :timeout     => 5

usage <<-USAGE

  This aggregate plugin will determine te average of a set of numeric values.

  DDL Example:

    summarize do
      aggregate average(:value)
    end

  Sample Output:

    host1.example.com
      Value: 10

    host2.example.com
      Value: 20


   Summary of Value:

      Average of Value: 15.000000

USAGE

