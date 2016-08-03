module Vup
  class Show
    getter! cr_version : ProjectVersion
    getter! yml_version : ProjectVersion
    getter! new_version : ProjectVersion

    def run
      validate_single_version
      load_version_cr
      validate_shard_version
      load_shard_yml
      validate_match_versions
      puts cr_version.version
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
      src.match(/version:\s(\d+.\d+\.\d+)/) do |m|
        @yml_version = ProjectVersion.from_string(m[0])
      end
    end

    def validate_match_versions
      return if (cr_version == yml_version)
      raise Exception.new("version.cr version != shard.yml version")
    end
  end
end
