module Vup
  class Up
    enum SemanticVersions
      MAJOR
      MINOR
      PATCH
    end

    def initialize(@option = SemanticVersions::PATCH)
    end

    def up

    end

    private def bumpup_version_cr

    end
  end
end

v = Vup::Version.new(Vup::Version::SemanticVersions::MAJOR)
pp v
