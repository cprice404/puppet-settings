# encoding: utf-8

require 'puppet_settings'

class PuppetSettings::BootstrapSettings
  def self.initialize_bootstrap_settings()
    os = is_windows? ? :windows : :unix
    user = is_root? ? :root : :user
    BOOTSTRAP_DEFAULTS[os][user]
  end

  private

  BOOTSTRAP_SETTINGS = [:conf_dir, :code_dir, :var_dir, :run_dir, :log_dir]

  BOOTSTRAP_DEFAULTS = {
      :unix => {
          :root => { :conf_dir => "/etc/puppetlabs/puppet",
                     :code_dir => "/etc/puppetlabs/code",
                     :var_dir => "/opt/puppetlabs/puppet/cache",
                     :run_dir => "/var/run/puppetlabs",
                     :log_dir => "/var/log/puppetlabs/puppet"},
          :user => { :conf_dir => "~/.puppetlabs/etc/puppet",
                     :code_dir => "~/.puppetlabs/etc/code",
                     :var_dir => "~/.puppetlabs/opt/puppet/cache",
                     :run_dir => "~/.puppetlabs/var/run",
                     :log_dir => "~/.puppetlabs/var/log"}
      },
      :windows => {
          # TODO
          :root => {},
          :user => ()
      }
  }

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