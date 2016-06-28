# encoding: utf-8

require 'puppet_settings'
require 'puppet_settings/puppet_settings_error'

PuppetSettingsError = PuppetSettings::PuppetSettingsError

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
end

