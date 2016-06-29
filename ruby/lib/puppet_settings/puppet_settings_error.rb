# encoding: utf-8

require 'puppet_settings'

class PuppetSettings::PuppetSettingsError < StandardError
  def initialize(message, cause = nil)
    super(message)
    @cause = cause
  end

  class ParseError < PuppetSettings::PuppetSettingsError
    def initialize(message, file, line, cause = nil)
      super("#{message}: file: #{file}, line: #{line}", cause)
    end
  end
end
