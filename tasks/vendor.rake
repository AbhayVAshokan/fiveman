begin
  require "automatiek"

  desc "Vendor a specific version of thor"
  Automatiek::RakeTask.new("thor") do |lib|
    lib.download = { github: "https://github.com/erikhuda/thor" }
    lib.namespace = "Thor"
    lib.prefix = "Fiveman"
    lib.vendor_lib = "lib/fiveman/vendor/thor"
  end
rescue LoadError
end
