require "yaml"

module Vup
  abstract class BaseVersion
    getter version : SemanticVersions | Nil = SemanticVersions::PATCH
    getter! cr_version : ProjectVersion
    getter! yml_version : ProjectVersion
    getter! dry_run : Bool
    getter! detail : Bool

    def initialize(@version = SemanticVersions::PATCH, @dry_run = false, @detail = false)
      @version_cr_path = ""
    end

    def run
      load_files
      action
      output_detail if detail
    end

    def load_files
      validate_single_version
      load_version_cr
      validate_shard_version
      load_shard_yml
      validate_match_versions
    end

    abstract def action

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

    private def version_cr_path
      @version_cr_path = Dir.glob(VERSION_CR_PATH).first if @version_cr_path == ""
      @version_cr_path
    end

    private def output_detail
      puts "#{version_cr_path}"
      puts "#{SHARD_PATH}"
    end
  end
end
