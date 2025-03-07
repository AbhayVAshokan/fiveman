require "time"

desc "Build the manual"
task :man do
  ENV['RONN_MANUAL']  = "Fiveman Manual"
  ENV['RONN_ORGANIZATION'] = "Fiveman #{Fiveman::VERSION}"
  sh "ronn -w -s toc -r5 --markdown man/*.ronn"
end

desc "Commit the manual to git"
task "man:commit" => :man do
  sh "git add README.md"
  sh "git commit -am 'update docs' || echo 'nothing to commit'"
  sh "git push"
end

desc "Generate the Github docs"
task :pages => "man:commit" do
  sh %{
    cp man/fiveman.1.html /tmp/fiveman.1.html
    git checkout gh-pages
    rm ./index.html
    cp /tmp/fiveman.1.html ./index.html
    git add -u index.html
    git commit -m "saving man page to github docs"
    git push origin -f gh-pages
    git checkout master
  }
end

def latest_release
  latest = File.read("Changelog.md").split("\n").first.split(" ")[1]
end

def newer_release
  tags = %x{ git tag --contains v#{latest_release} | grep -v pre }.split("\n").sort_by do |tag|
    Gem::Version.new(tag[1..-1])
  end
  tags[1]
end

desc "Generate a Changelog"
task :changelog do
  while release = newer_release
    entry = %x{ git show --format="%cd" #{release} | head -n 1 }
    puts entry
    date = Time.parse(entry.chomp).strftime("%Y-%m-%d")

    message  = "## #{release[1..-1]} (#{date})\n\n"
    message += %x{ git log --format="* %s  [%an]" v#{latest_release}..#{release} | grep -v "Merge pull request" | grep -v "* #{release[1..-1]}" | grep -v "* update docs" }

    changelog = File.read("Changelog.md")
    changelog = message + "\n" + changelog

    puts release

    File.open("Changelog.md", "w") do |file|
      file.print changelog
    end
  end
end

desc "Cut a release"
task :release do
  Rake::Task["changelog"].invoke
  Rake::Task["pages"].invoke
  Rake::Task["gem:release"].invoke
end
