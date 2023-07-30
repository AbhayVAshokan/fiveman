require "fiveman"
require "fiveman/helpers"
require "pathname"

module Fiveman::Export
  extend Fiveman::Helpers

  class Exception < ::Exception; end

  def self.formatter(format)
    begin
      require "fiveman/export/#{ format.tr('-', '_') }"
      classy_format = classify(format)
      formatter     = constantize("Fiveman::Export::#{ classy_format }")
    rescue NameError => ex
      error "Unknown export format: #{format} (no class Fiveman::Export::#{ classy_format })."
    rescue LoadError => ex
      error "Unknown export format: #{format} (unable to load file 'fiveman/export/#{ format.tr('-', '_') }')."
    end
  end

  def self.error(message)
    raise Fiveman::Export::Exception.new(message)
  end

end

require "fiveman/export/base"
require "fiveman/export/inittab"
require "fiveman/export/upstart"
require "fiveman/export/daemon"
require "fiveman/export/bluepill"
require "fiveman/export/runit"
require "fiveman/export/supervisord"
require "fiveman/export/launchd"
require "fiveman/export/systemd"
