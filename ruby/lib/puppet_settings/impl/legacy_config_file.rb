# encoding: utf-8

require 'puppet_settings/impl'
require 'puppet_settings/impl/ini_file'
require 'puppet_settings/puppet_settings_error'
require 'stringio'

# @api private
class PuppetSettings::Impl::LegacyConfigFile

  ParseError = PuppetSettings::PuppetSettingsError::ParseError

  def self.parse(config_file)
    ini = PuppetSettings::Impl::IniFile.parse(File.read(config_file))

    result = {}
    unique_sections_in(ini, config_file, [:main, :master, :agent]).each do |section_name|
      result[section_name] = {}
      ini.lines_in(section_name).each do |line|
        if line.is_a?(PuppetSettings::Impl::IniFile::SettingLine)
          result[section_name][line.name] = convert_value(line.value)
        elsif line.text !~ /^\s*#|^\s*$/
          raise ParseError.new("Could not match line '#{line.text}'", config_file, line.line_number)
        end
      end
    end
    result
  end

  private

  def self.unique_sections_in(ini, file, allowed_section_names)
    ini.section_lines.collect do |section|
      if !allowed_section_names.empty? && !allowed_section_names.include?(section.name.intern)
        raise ParseError.new("Illegal section '#{section.name}' in config file", file, section.line_number)
      end
      section.name
    end.uniq
  end

  def self.convert_value(value)
    # Handle different data types correctly
    return case value
             when /^false$/i; false
             when /^true$/i; true
             when /^\d+$/i; Integer(value)
             when true; true
             when false; false
             else
               value.gsub(/^["']|["']$/,'').sub(/\s+$/, '')
           end
  end
end