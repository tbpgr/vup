require 'open3'
require 'fileutils'
require 'yaml'

module Task
  module Constants
    BIN = 'vup'.freeze
    VERSION = 'v' + YAML.load_file('./shard.yml').tap { |e| break e['version'] }
    DEBUG_DIR = "#{::Dir.pwd}/debug".freeze
    DEBUG_PATH = "#{DEBUG_DIR}/#{BIN}".freeze
    RELEASE_DIR = "#{::Dir.pwd}/pkg".freeze
    VERSION_RELEASE_DIR = "#{RELEASE_DIR}/#{VERSION}".freeze
    VERSION_RELEASE_PATH = "#{VERSION_RELEASE_DIR}/#{BIN}".freeze
    LATEST_RELEASE_DIR = "#{RELEASE_DIR}/latest".freeze
    LATEST_RELEASE_PATH = "#{LATEST_RELEASE_DIR}/#{BIN}".freeze
  end
end

def build(out_path, optons = nil)
  FileUtils.mkdir_p(File.dirname(out_path))
  o, s = Open3.capture2e("crystal build bin/vup.cr -o #{out_path} #{optons}")
  return if s.success?
  puts o
  Kernel.exit 1
end

namespace :build do
  desc 'build (debug mode)'
  task :debug do
    build(Task::Constants::DEBUG_PATH)
  end

  desc 'build (release mode)'
  task :release do
    build(Task::Constants::LATEST_RELEASE_PATH, '--release')
    FileUtils.mkdir_p(Task::Constants::VERSION_RELEASE_DIR)
    FileUtils.copy(Task::Constants::LATEST_RELEASE_PATH, Task::Constants::VERSION_RELEASE_DIR)
  end
end

desc 'release latest package'
task :release do
  if `which ghr`.empty?
    STDERR.puts('Release task uses tcnksm/ghr so please do `brew tap tcnksm/ghr;brew install ghr` first.')
    exit(false)
  end
  `ghr #{Task::Constants::VERSION} #{Task::Constants::LATEST_RELEASE_DIR}`
end

desc "generate badge"
task :badge do
  badge_url = "[![shards version](https://img.shields.io/badge/shards-#{Task::Constants::VERSION}-brightgreen.svg)](https://github.com/tbpgr/homebrew-vup)"
  readme_file = 'README.md'
  readme = File.read(readme_file)
  regex = /^\[\!\[shards version\]\(.+\)$/
  base_badge = readme.match(regex)
  if base_badge.nil?
    File.open(readme_file, "w") { |f|f.puts "#{badge_url}\n#{readme}" }
  elsif (base_badge[0] != badge_url)
    File.open(readme_file, "w") { |f|f.puts readme.gsub(regex, badge_url) }
  else
    puts "Badge already up-to-date"
  end
end
