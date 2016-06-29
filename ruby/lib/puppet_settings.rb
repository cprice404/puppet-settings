# encoding: utf-8

class PuppetSettings
  # these requires have to be in here to prevent circular dependencies :(
  require 'puppet_settings/puppet_settings_error'
  require 'puppet_settings/impl/bootstrap_settings'
  require 'puppet_settings/impl/legacy_config_file'
  require 'hocon'
  require 'hocon/config_error'

  ConfigParseError = Hocon::ConfigError::ConfigParseError

  def self.initialize_settings(overrides, run_mode = :user)
    unless RUN_MODES.include?(run_mode)
      raise PuppetSettings::PuppetSettingsError.new("Unrecognized run mode '#{run_mode}'; valid run modes are ':#{RUN_MODES.join("', ':")}'")
    end
    bootstrap_settings = PuppetSettings::Impl::BootstrapSettings.initialize_bootstrap_settings(overrides)
    conf = parse_config_file(bootstrap_settings[:config])
    conf = PuppetSettings::Impl::Utils.symbolize_keys!(conf)
    conf.merge(bootstrap_settings).merge(overrides)
  end

  private

  RUN_MODES = [:master, :agent, :user]

  def self.parse_config_file(config_file)
    begin
      Hocon.load(config_file)
    rescue ConfigParseError => e
      conf = PuppetSettings::Impl::LegacyConfigFile.parse(config_file)
      # TODO: deal with run_mode
      conf["main"]
    end
  end

end