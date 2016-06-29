# encoding: utf-8

require 'spec_helper'
require 'puppet_settings'
require 'puppet_settings/puppet_settings_error'
require 'puppet_settings/impl/bootstrap_settings'

PuppetSettingsError = PuppetSettings::PuppetSettingsError
BOOTSTRAP_SETTINGS = PuppetSettings::Impl::BootstrapSettings::BOOTSTRAP_SETTINGS

describe PuppetSettings do
  context "run_mode" do
    it "should raise error if run_mode is anything other than :master, :agent, or :user" do
      expect {
        PuppetSettings.initialize_settings({}, "foo")
      }.to raise_error(PuppetSettingsError,
                         "Unrecognized run mode 'foo'; valid run modes are ':master', ':agent', ':user'")
      expect { PuppetSettings.initialize_settings({}, 42) }.to raise_error(PuppetSettingsError)
      expect { PuppetSettings.initialize_settings({}, :foo) }.to raise_error(PuppetSettingsError)
    end
  end

  context "bootstrap settings" do
    it "defaults to directories under ~ for non-root users" do
      allow(PuppetSettings::Impl::BootstrapSettings).to receive(:is_root?).and_return(false)
      expect(
        PuppetSettings.initialize_settings({}).select do |key, value|
          BOOTSTRAP_SETTINGS.include? key
        end
      ).to eq({:confdir => "~/.puppetlabs/etc/puppet",
               :config_file_name => "puppet.conf",
               :config => "~/.puppetlabs/etc/puppet/puppet.conf",
               :codedir => "~/.puppetlabs/etc/code",
               :vardir => "~/.puppetlabs/opt/puppet/cache",
               :rundir => "~/.puppetlabs/var/run",
               :logdir => "~/.puppetlabs/var/log"})
    end

    it "uses system directories for root user" do
      allow(PuppetSettings::Impl::BootstrapSettings).to receive(:is_root?).and_return(true)
      expect(
          PuppetSettings.initialize_settings({}).select do |key, value|
            BOOTSTRAP_SETTINGS.include? key
          end
      ).to eq({:confdir => "/etc/puppetlabs/puppet",
               :config_file_name => "puppet.conf",
               :config => "/etc/puppetlabs/puppet/puppet.conf",
               :codedir => "/etc/puppetlabs/code",
               :vardir => "/opt/puppetlabs/puppet/cache",
               :rundir => "/var/run/puppetlabs",
               :logdir => "/var/log/puppetlabs/puppet"})
    end

    it "TODO: works on windows" do
      skip("Windows support not yet implemented")
    end
  end

  context "bootstrap settings overrides" do
    it "overrides defaults if overrides are passed in" do
      expect(
          PuppetSettings.initialize_settings(
              {:confdir => "/foo/conf",
               :config_file_name => "puppetfoo.conf",
               :codedir => "/foo/code",
               :vardir => "/foo/var",
               :rundir => "/foo/run",
               :logdir => "/foo/log"}).select do |key, value|
            BOOTSTRAP_SETTINGS.include? key
          end
      ).to eq({:confdir => "/foo/conf",
               :config_file_name => "puppetfoo.conf",
               :config => "/foo/conf/puppetfoo.conf",
               :codedir => "/foo/code",
               :vardir => "/foo/var",
               :rundir => "/foo/run",
               :logdir => "/foo/log"})
    end
  end

  context "config file paths and formats" do
    context "hocon config files" do
      it "parses file with default name" do
        expect(
            PuppetSettings.initialize_settings({:confdir => fixture_path("hocon")})[:masterport]
        ).to eq(9140)
      end
      it "parses file with custom name" do
        expect(
            PuppetSettings.initialize_settings({:confdir => fixture_path("hocon"),
                                                :config_file_name => "othername.conf"})[:masterport]
        ).to eq(9140)
      end
    end

    context "ini config files" do
      it "parses file with default name" do
        expect(
            PuppetSettings.initialize_settings({:confdir => fixture_path("ini")})[:masterport]
        ).to eq(9140)
      end
    end
  end

end

