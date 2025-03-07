require "erb"
require "fileutils"
require "tmpdir"

def assemble(source, target, perms=0644)
  FileUtils.mkdir_p(File.dirname(target))
  File.open(target, "w") do |f|
    f.puts ERB.new(File.read(source)).result(binding)
  end
  File.chmod(perms, target)
end

def assemble_distribution(target_dir=Dir.pwd)
  distribution_files.each do |source|
    target = source.gsub(/^#{project_root}/, target_dir)
    FileUtils.mkdir_p(File.dirname(target))
    FileUtils.cp(source, target)
  end
end

GEM_BLACKLIST = %w( bundler fiveman )

def assemble_gems(target_dir=Dir.pwd)
  lines = %x{ cd #{project_root} && bundle show }.strip.split("\n")
  raise "error running bundler" unless $?.success?

  %x{ env BUNDLE_WITHOUT="development:test" bundle show }.split("\n").each do |line|
    if line =~ /^  \* (.*?) \((.*?)\)/
      next if GEM_BLACKLIST.include?($1)
      puts "vendoring: #{$1}-#{$2}"
      gem_dir = %x{ bundle show #{$1} }.strip
      FileUtils.mkdir_p "#{target_dir}/vendor/gems"
      %x{ cp -R "#{gem_dir}" "#{target_dir}/vendor/gems" }
    end
  end.compact
end

def beta?
  Fiveman::VERSION.to_s =~ /pre/
end

def clean(file)
  rm file if File.exists?(file)
end

def distribution_files(type=nil)
  require "fiveman/distribution"
  base_files = Fiveman::Distribution.files
  type_files = type ?
    Dir[File.expand_path("../../dist/resources/#{type}/**/*", __FILE__)] : []
  base_files.concat(type_files)
end

def mkchdir(dir)
  FileUtils.mkdir_p(dir)
  Dir.chdir(dir) do |dir|
    yield(File.expand_path(dir))
  end
end

def pkg(filename)
  File.expand_path("../../pkg/#{filename}", __FILE__)
end

def project_root
  File.expand_path("../..", __FILE__)
end

def resource(name)
  File.expand_path("../../dist/resources/#{name}", __FILE__)
end

def s3_connect
  return if @s3_connected

  require "aws/s3"

  unless ENV["FIVEMAN_RELEASE_ACCESS"] && ENV["FIVEMAN_RELEASE_SECRET"]
    puts "please set FIVEMAN_RELEASE_ACCESS and FIVEMAN_RELEASE_SECRET in your environment"
    exit 1
  end

  AWS::S3::Base.establish_connection!(
    :access_key_id => ENV["FIVEMAN_RELEASE_ACCESS"],
    :secret_access_key => ENV["FIVEMAN_RELEASE_SECRET"]
  )

  @s3_connected = true
end

def store(package_file, filename, bucket="assets.fiveman.io")
  s3_connect
  puts "storing: #{filename}"
  AWS::S3::S3Object.store(filename, File.open(package_file), bucket, :access => :public_read)
end

def tempdir
  Dir.mktmpdir do |dir|
    Dir.chdir(dir) do
      yield(dir)
    end
  end
end

def version
  require "fiveman/version"
  Fiveman::VERSION
end

Dir[File.expand_path("../../dist/**/*.rake", __FILE__)].each do |rake|
  import rake
end
