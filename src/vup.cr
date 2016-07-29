require "./vup/*"

module Vup
  class Up
    enum SemanticVersions
      MAJOR
      MINOR
      PATCH
    end
    getter version : SemanticVersions | Nil

    def initialize(@version = SemanticVersions::PATCH)
    end

    def bumpup_files
      # read version
      # validate_single_version : if multi version.cr exist, raise error
      # read shard.yml
      # compare version.cr to shard.yml : if version is not same, raise error
      # get bumpup version
      # override version.cr : with stdout message
      # override shard.yml : with stdout message 
    end

    def read_version_cr

    end

    def read_shard_yml

    end

    def bumpup

    end
  end
end
