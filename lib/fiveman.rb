require "fiveman/version"

module Fiveman

  def self.runner
    File.expand_path("../../bin/fiveman-runner", __FILE__)
  end

  def self.ruby_18?
    defined?(RUBY_VERSION) and RUBY_VERSION =~ /^1\.8\.\d+/
  end

  def self.windows?
    defined?(RUBY_PLATFORM) and RUBY_PLATFORM =~ /(win|w)32$/
  end

end
