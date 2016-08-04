require "yaml"

module Vup
  class Up
    getter version : SemanticVersions | Nil = SemanticVersions::PATCH
    getter! cr_version : ProjectVersion
    getter! yml_version : ProjectVersion
    getter! new_version : ProjectVersion

    def initialize(@version = SemanticVersions::PATCH)
      @version_cr_path = ""
    end

    def run(dry_run = false)
      load_files
      if dry_run
        puts new_version.version
        puts version_cr_path
        puts SHARD_PATH
      else
        bumpup_files
      end
    end

    def load_files
      validate_single_version
      load_version_cr
      validate_shard_version
      load_shard_yml
      validate_match_versions
    end

    def bumpup_files
      update_files
    end

    def new_version
      @new_version ||= cr_version.dup.bumpup(version)
    end

    def validate_single_version
      return if Dir.glob(VERSION_CR_PATH).size == 1
      raise Exception.new("Invalid count(version.cr : #{Dir.glob(VERSION_CR_PATH).size})")
    end

    def load_version_cr
      src = File.read(Dir.glob(VERSION_CR_PATH).first)
      src.match(/VERSION\s*=\s*"(\d+\.\d+\.\d+)"/) do |m|
        @cr_version = ProjectVersion.from_string(m[1])
      end
    end

    def validate_shard_version
      return if Dir.glob(SHARD_PATH).size == 1
      raise Exception.new("Invalid count(shard.yml : #{Dir.glob(SHARD_PATH).size})")
    end

    def load_shard_yml
      src = File.read(Dir.glob(SHARD_PATH).first)
      @yml_version = ProjectVersion.from_string(YAML.parse(src)["version"].as_s)
    end

    def validate_match_versions
      return if (cr_version == yml_version)
      raise Exception.new("version.cr version != shard.yml version")
    end

    def update_files
      update_version_cr(new_version)
      update_shard_yml(new_version)
      STDOUT.puts(new_version.version)
    end

    private def update_version_cr(new_version)
      src = File.read(version_cr_path)
      new_src = src.gsub(/\d+.\d+\.\d+/, new_version.version)
      File.write(version_cr_path, new_src)
    end

    private def version_cr_path
      @version_cr_path = Dir.glob(VERSION_CR_PATH).first if @version_cr_path == ""
      @version_cr_path
    end

    private def update_shard_yml(new_version)
      src = File.read(SHARD_PATH)
      new_src = src.gsub(/version: \d+.\d+\.\d+/, "version: #{new_version.version}")
      File.write(SHARD_PATH, new_src)
    end
  end
end
