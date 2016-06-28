# encoding: utf-8

require 'puppet_settings'
require 'puppet_settings/puppet_settings_error'
require 'puppet_settings/bootstrap_settings'

PuppetSettingsError = PuppetSettings::PuppetSettingsError
BOOTSTRAP_SETTINGS = PuppetSettings::BootstrapSettings::BOOTSTRAP_SETTINGS

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
      allow(PuppetSettings::BootstrapSettings).to receive(:is_root?).and_return(false)
      expect(
        PuppetSettings.initialize_settings({}, :master).select do |key, value|
          BOOTSTRAP_SETTINGS.include? key
        end
      ).to eq({:conf_dir => "~/.puppetlabs/etc/puppet",
               :code_dir => "~/.puppetlabs/etc/code",
               :var_dir => "~/.puppetlabs/opt/puppet/cache",
               :run_dir => "~/.puppetlabs/var/run",
               :log_dir => "~/.puppetlabs/var/log"})
    end

    it "uses system directories for root user" do
      allow(PuppetSettings::BootstrapSettings).to receive(:is_root?).and_return(true)
      expect(
          PuppetSettings.initialize_settings({}, :master).select do |key, value|
            BOOTSTRAP_SETTINGS.include? key
          end
      ).to eq({:conf_dir => "/etc/puppetlabs/puppet",
               :code_dir => "/etc/puppetlabs/code",
               :var_dir => "/opt/puppetlabs/puppet/cache",
               :run_dir => "/var/run/puppetlabs",
               :log_dir => "/var/log/puppetlabs/puppet"})
    end


    it "TODO: works on windows" do
      skip("Windows support not yet implemented")
    end
  end
end

