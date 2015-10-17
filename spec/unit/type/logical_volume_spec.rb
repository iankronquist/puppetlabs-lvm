#!/usr/bin/env rspec

require 'spec_helper'
describe Puppet::Type.type(:logical_volume) do
  it 'raises an ArgumentError when the name has a file separator' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => '/dev/lol',
        :ensure       => :present,
        :volume_group => 'myvg',
        :size         => '20G',
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter name failed on Logical_volume[/dev/lol]: Volume names must be entirely unqualified')
  end

  it 'does not raise an ArgumentError when the name has no file separator' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'myvg',
        :ensure       => :present,
        :volume_group => 'myvg',
        :size         => '20G',
      )
    }.to_not raise_error
  end


end

