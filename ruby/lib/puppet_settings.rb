# encoding: utf-8

class PuppetSettings
  # this require has to be here to prevent a circular dependency :(
  require 'puppet_settings/puppet_settings_error'

  RUN_MODES = [:master, :agent, :user]

  def self.initialize_settings(overrides, run_mode)
    unless RUN_MODES.include?(run_mode)
      raise PuppetSettings::PuppetSettingsError.new("Unrecognized run mode '#{run_mode}'; valid run modes are ':#{RUN_MODES.join("', ':")}'")
    end
  end
end