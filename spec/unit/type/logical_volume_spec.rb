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

  it 'invalid logical initial volume size raises error (char)' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'myvg',
        :ensure       => :present,
        :volume_group => 'myvg',
        :initial_size => 'abcd',
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter initial_size failed on Logical_volume[myvg]: abcd is not a valid logical volume size')
  end

  it 'invalid logical initial volume size raises error (suffix)' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'myvg',
        :ensure       => :present,
        :volume_group => 'myvg',
        :initial_size => '20A',
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter initial_size failed on Logical_volume[myvg]: 20A is not a valid logical volume size')
  end

  it 'valid logical volume initial size does not raise error' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'myvg',
        :ensure       => :present,
        :volume_group => 'myvg',
        :initial_size => '20G',
      )
    }.to_not raise_error
  end

  it 'invalid logical volume size raises error (char)' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'myvg',
        :ensure       => :present,
        :volume_group => 'myvg',
        :size         => 'lucy<3',
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter size failed on Logical_volume[myvg]: lucy<3 is not a valid logical volume size')
  end

  it 'invalid logical volume size raises error (suffix)' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'myvg',
        :ensure       => :present,
        :volume_group => 'myvg',
        :size         => '20Q',
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter size failed on Logical_volume[myvg]: 20Q is not a valid logical volume size')
  end

  it 'invalid logical volume extent raises error' do 
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'zerocool',
        :ensure       => :present,
        :volume_group => 'myvg',
        :size         => '10M',
        :extents      => 'acidburn',
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter extents failed on Logical_volume[zerocool]: acidburn is not a valid logical volume extent')
  end

  it 'valid logical volume extent does not raise error' do 
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'zerocool',
        :ensure       => :present,
        :volume_group => 'myvg',
        :size         => '10M',
        :extents      => '1%vg',
      )
    }.to_not raise_error
  end

  it 'persistent which is not true or false raises error' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'simba',
        :ensure       => :present,
        :volume_group => 'rafiki',
        :size         => '10M',
        :persistent   => 'nala',
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter persistent failed on Logical_volume[simba]: persistent must be either be true or false')
  end

  it 'persistent is true does not raise error' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'simba',
        :ensure       => :present,
        :volume_group => 'rafiki',
        :size         => '10M',
        :persistent   => :true,
      )
    }.to_not raise_error
  end

  it 'minor not set to integer between 0 and 255 raises error' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'ringo',
        :ensure       => :present,
        :volume_group => 'george',
        :size         => '10M',
        :minor        => 910
      )
    }.to raise_error(Puppet::ResourceError,
                     'Parameter minor failed on Logical_volume[ringo]: 910 is not a valid value for minor. It must be an integer between 0 and 255')
  end

  it 'minor not set to integer between 0 and 255 raises error' do
    expect {
      resource = Puppet::Type.type(:logical_volume).new(
        :name         => 'ringo',
        :ensure       => :present,
        :volume_group => 'george',
        :size         => '10M',
        :minor        => 1
      )
    }.to_not raise_error
  end
end
