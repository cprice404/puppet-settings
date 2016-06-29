# encoding: utf-8

require 'puppet_settings/impl'

class PuppetSettings::Impl::Utils
  def self.symbolize_keys!(h)
    h.keys.each do |key|
      h[key.to_sym] = h.delete(key)
    end
    h
  end
end

