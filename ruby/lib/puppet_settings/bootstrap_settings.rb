# encoding: utf-8

require 'puppet_settings'

class PuppetSettings::BootstrapSettings
  def self.initialize_bootstrap_settings()
    os = is_windows? ? :windows : :unix
    user = is_root? ? :root : :user
    BOOTSTRAP_DEFAULTS[os][user]
  end

  private

  BOOTSTRAP_SETTINGS = [:confdir, :codedir, :vardir, :rundir, :logdir]

  BOOTSTRAP_DEFAULTS = {
      :unix => {
          :root => { :confdir => "/etc/puppetlabs/puppet",
                     :codedir => "/etc/puppetlabs/code",
                     :vardir => "/opt/puppetlabs/puppet/cache",
                     :rundir => "/var/run/puppetlabs",
                     :logdir => "/var/log/puppetlabs/puppet"},
          :user => { :confdir => "~/.puppetlabs/etc/puppet",
                     :codedir => "~/.puppetlabs/etc/code",
                     :vardir => "~/.puppetlabs/opt/puppet/cache",
                     :rundir => "~/.puppetlabs/var/run",
                     :logdir => "~/.puppetlabs/var/log"}
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