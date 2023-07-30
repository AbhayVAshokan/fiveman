file pkg("fiveman-#{version}.gem") => distribution_files do |t|
  sh "gem build fiveman.gemspec"
  sh "mv fiveman-#{version}.gem #{t.name}"
end

task "gem:build" => pkg("fiveman-#{version}.gem")

task "gem:clean" do
  clean pkg("fiveman-#{version}.gem")
end

task "gem:release" => "gem:build" do |t|
  sh "gem push #{pkg("fiveman-#{version}.gem")} || echo 'error'"
end
