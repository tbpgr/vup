require "yaml"

module Vup
  class Up
    getter version : SemanticVersions | Nil = SemanticVersions::PATCH
    getter! cr_version : ProjectVersion
    getter! yml_version : ProjectVersion
    getter! new_version : ProjectVersion

    def initialize(@version = SemanticVersions::PATCH)
    end

    def bumpup_files
      validate_single_version
      load_version_cr
      validate_shard_version
      load_shard_yml
      validate_match_versions
      update_files(bumpup_version)
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

    def bumpup_version
      @new_version = cr_version.dup.bumpup(version)
    end

    def update_files(new_version)
      update_version_cr(new_version)
      update_shard_yml(new_version)
      STDOUT.puts(new_version.version)
    end

    private def update_version_cr(new_version)
      version_cr = Dir.glob(VERSION_CR_PATH).first
      src = File.read(version_cr)
      new_src = src.gsub(/\d+.\d+\.\d+/, new_version.version)
      File.write(version_cr, new_src)
    end

    private def update_shard_yml(new_version)
      src = File.read(SHARD_PATH)
      new_src = src.gsub(/version: \d+.\d+\.\d+/, "version: #{new_version.version}")
      File.write(SHARD_PATH, new_src)
    end
  end
end
