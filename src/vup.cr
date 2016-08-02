require "./vup/*"

module Vup
  class Up
    enum SemanticVersions
      MAJOR
      MINOR
      PATCH
    end

    VERSION_CR_PATH = "\./**/version\.cr"
    SHARD_PATH = "\./shard\.yml"

    getter version : SemanticVersions | Nil = SemanticVersions::PATCH
    getter major : Int32 = 0
    getter minor : Int32 = 0
    getter patch : Int32 = 0
    getter cr_version : String | Nil
    getter yml_version : String | Nil
    getter new_version : String | Nil

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
      src.match(/VERSION\s*=\s*"(\d+)\.(\d+)\.(\d+)"/)
      @major, @minor, @patch = $1.to_i, $2.to_i, $3.to_i
      @cr_version = "#{@major}.#{@minor}.#{@patch}"
    end

    def validate_shard_version
      return if Dir.glob(SHARD_PATH).size == 1
      raise Exception.new("Invalid count(shard.yml : #{Dir.glob(SHARD_PATH).size})")
    end

    def load_shard_yml
      src = File.read(Dir.glob(SHARD_PATH).first)
      src.match(/version:\s(\d+.\d+\.\d+)/)
      @yml_version = $1
    end

    def validate_match_versions
      return if (cr_version == yml_version)
      raise Exception.new("version.cr version != shard.yml version")
    end

    def bumpup_version
      case version
      when SemanticVersions::MAJOR
        return "#{@major + 1}.0.0"
      when SemanticVersions::MINOR
        return "#{@major}.#{@minor + 1}.0"
      when SemanticVersions::PATCH
        return "#{@major}.#{@minor}.#{@patch + 1}"
      end
    end

    def update_files(new_version)
      update_version_cr(new_version)
      update_shard_yml(new_version)
    end

    private def update_version_cr(new_version)
      version_cr = Dir.glob(VERSION_CR_PATH).first
      src = File.read(version_cr)
      new_src = src.gsub(/\d+.\d+\.\d+/, new_version)
      File.write(version_cr, new_src)
    end

    private def update_shard_yml(new_version)
      src = File.read(SHARD_PATH)
      new_src = src.gsub(/version: \d+.\d+\.\d+/, "version: #{new_version}")
      File.write(SHARD_PATH, new_src)
    end
  end
end
