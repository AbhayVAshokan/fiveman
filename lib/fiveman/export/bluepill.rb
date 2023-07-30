require "erb"
require "fiveman/export"

class Fiveman::Export::Bluepill < Fiveman::Export::Base

  def export
    super
    clean "#{location}/#{app}.pill"
    write_template "bluepill/master.pill.erb", "#{app}.pill", binding
  end

end
