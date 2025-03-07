require "rbconfig"

class Fiveman::Thor
  module Base
    class << self
      attr_writer :shell

      # Returns the shell used in all Fiveman::Thor classes. If you are in a Unix platform
      # it will use a colored log, otherwise it will use a basic one without color.
      #
      def shell
        @shell ||= if ENV["THOR_SHELL"] && !ENV["THOR_SHELL"].empty?
          Fiveman::Thor::Shell.const_get(ENV["THOR_SHELL"])
        elsif RbConfig::CONFIG["host_os"] =~ /mswin|mingw/ && !ENV["ANSICON"]
          Fiveman::Thor::Shell::Basic
        else
          Fiveman::Thor::Shell::Color
        end
      end
    end
  end

  module Shell
    SHELL_DELEGATED_METHODS = [:ask, :error, :set_color, :yes?, :no?, :say, :say_status, :print_in_columns, :print_table, :print_wrapped, :file_collision, :terminal_width]
    attr_writer :shell

    autoload :Basic, "fiveman/vendor/thor/lib/thor/shell/basic"
    autoload :Color, "fiveman/vendor/thor/lib/thor/shell/color"
    autoload :HTML,  "fiveman/vendor/thor/lib/thor/shell/html"

    # Add shell to initialize config values.
    #
    # ==== Configuration
    # shell<Object>:: An instance of the shell to be used.
    #
    # ==== Examples
    #
    #   class MyScript < Fiveman::Thor
    #     argument :first, :type => :numeric
    #   end
    #
    #   MyScript.new [1.0], { :foo => :bar }, :shell => Fiveman::Thor::Shell::Basic.new
    #
    def initialize(args = [], options = {}, config = {})
      super
      self.shell = config[:shell]
      shell.base ||= self if shell.respond_to?(:base)
    end

    # Holds the shell for the given Fiveman::Thor instance. If no shell is given,
    # it gets a default shell from Fiveman::Thor::Base.shell.
    def shell
      @shell ||= Fiveman::Thor::Base.shell.new
    end

    # Common methods that are delegated to the shell.
    SHELL_DELEGATED_METHODS.each do |method|
      module_eval <<-METHOD, __FILE__, __LINE__
        def #{method}(*args,&block)
          shell.#{method}(*args,&block)
        end
      METHOD
    end

    # Yields the given block with padding.
    def with_padding
      shell.padding += 1
      yield
    ensure
      shell.padding -= 1
    end

  protected

    # Allow shell to be shared between invocations.
    #
    def _shared_configuration #:nodoc:
      super.merge!(:shell => shell)
    end
  end
end
