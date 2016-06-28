# encoding: utf-8

class PuppetSettings
  # these requires have to be in here to prevent circular dependencies :(
  require 'puppet_settings/puppet_settings_error'
  require 'puppet_settings/bootstrap_settings'

  RUN_MODES = [:master, :agent, :user]

  def self.initialize_settings(overrides, run_mode)
    unless RUN_MODES.include?(run_mode)
      raise PuppetSettings::PuppetSettingsError.new("Unrecognized run mode '#{run_mode}'; valid run modes are ':#{RUN_MODES.join("', ':")}'")
    end
    PuppetSettings::BootstrapSettings.initialize_bootstrap_settings().merge(overrides)
  end
end