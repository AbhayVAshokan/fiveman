require "erb"
require "fiveman/export"

class Fiveman::Export::Supervisord < Fiveman::Export::Base

  def export
    super

    Dir["#{location}/#{app}.conf"].each do |file|
      clean file
    end

    write_template "supervisord/app.conf.erb", "#{app}.conf", binding
  end

end
