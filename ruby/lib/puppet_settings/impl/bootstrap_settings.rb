# encoding: utf-8

require 'puppet_settings'
require 'puppet_settings/impl'
require 'puppet_settings/impl/utils'
require 'hocon/config_factory'
require 'hocon/config_resolve_options'
require 'hocon/config_value_factory'

class PuppetSettings::Impl::BootstrapSettings
  def self.initialize_bootstrap_settings(overrides)
    # TODO: there are currently no defaults files for windows and nothing
    #  for windows is implemented at all.
    os_dir = is_windows? ? "windows" : "unix"
    user_file = is_root? ? "root_user.conf" : "normal_user.conf"
    defaults_file = File.join(File.dirname(__FILE__), "defaults", "bootstrap", os_dir, user_file)
    # this gives us the raw, unresolved config
    conf = Hocon::ConfigFactory.parse_file(defaults_file)

    # here we inject the relevant user overrides; we need to do this
    # because `:config` is interpolated and they may have overridden
    # one of its components
    overrides.select { |k,v| BOOTSTRAP_SETTINGS.include? k }.each do |k, v|
      conf = conf.with_value(k.to_s, Hocon::ConfigValueFactory.from_any_ref(v, "user override"))
    end

    # now we resolve the config
    conf = Hocon::ConfigFactory.load_from_config(
        conf, Hocon::ConfigResolveOptions.defaults)
    PuppetSettings::Impl::Utils.symbolize_keys!(conf.root.unwrapped)
  end

  private

  DEFAULT_CONFIG = "$confdir/$config_file_name"
  DEFAULT_CONFIG_FILE_NAME = "puppet.conf"

  BOOTSTRAP_SETTINGS = [:confdir, :config_file_name, :config,
                        :codedir, :vardir, :rundir, :logdir]


  def self.is_windows?()
    # TODO: implement
    false
  end

  def self.is_windows_admin?()
    # TODO: implement
    false
  end

  def self.is_root?()
    if is_windows?
      is_windows_admin?
    else
      Process.uid == 0
    end
  end

end