require 'spec_helper'

describe 'apache::mod::auth_kerb', :type => :class do
  let :pre_condition do
    'include apache'
  end
  context "on a Debian OS", :compile do
    let :facts do
      {
        :id                     => 'root',
        :kernel                 => 'Linux',
        :lsbdistcodename        => 'squeeze',
        :osfamily               => 'Debian',
        :operatingsystem        => 'Debian',
        :operatingsystemrelease => '6',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :concat_basedir         => '/dne',
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod("auth_kerb") }
    it { is_expected.to contain_package("libapache2-mod-auth-kerb") }
  end
  context "on a RedHat OS", :compile do
    let :facts do
      {
        :id                     => 'root',
        :kernel                 => 'Linux',
        :osfamily               => 'RedHat',
        :operatingsystem        => 'RedHat',
        :operatingsystemrelease => '6',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :concat_basedir         => '/dne',
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod("auth_kerb") }
    it { is_expected.to contain_package("mod_auth_kerb") }
  end
  context "on a FreeBSD OS", :compile do
    let :facts do
      {
        :id                     => 'root',
        :kernel                 => 'FreeBSD',
        :osfamily               => 'FreeBSD',
        :operatingsystem        => 'FreeBSD',
        :operatingsystemrelease => '9',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
        :concat_basedir         => '/dne',
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod("auth_kerb") }
    it { is_expected.to contain_package("www/mod_auth_kerb2") }
  end
  context "on a Gentoo OS", :compile do
    let :facts do
      {
        :id                     => 'root',
        :kernel                 => 'Linux',
        :osfamily               => 'Gentoo',
        :operatingsystem        => 'Gentoo',
        :path                   => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/bin',
        :operatingsystemrelease => '3.16.1-gentoo',
        :concat_basedir         => '/dne',
        :is_pe                  => false,
      }
    end
    it { is_expected.to contain_class("apache::params") }
    it { is_expected.to contain_apache__mod("auth_kerb") }
    it { is_expected.to contain_package("www-apache/mod_auth_kerb") }
  end
end
