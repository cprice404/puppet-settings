# encoding: utf-8

require 'puppet_settings'

class PuppetSettings::PuppetSettingsError < StandardError
  def initialize(message, cause = nil)
    super(message)
    @cause = cause
  end
end
