module Vup
  class ProjectVersion
    property major : Int32 = 0
    property minor : Int32 = 0
    property patch : Int32 = 0

    VERSION_PATTERN = /(\d+).(\d+)\.(\d+)/

    def self.from_string(org : String)
      ProjectVersion.new.tap do |e|
        org.match(VERSION_PATTERN) do |m|
          e.major = m[1].to_i
          e.minor = m[2].to_i
          e.patch = m[3].to_i
        end
      end
    end

    def version
      "#{@major}.#{@minor}.#{@patch}"
    end

    def bumpup(mode)
      case mode
      when Vup::SemanticVersions::MAJOR
        @major += 1
        @minor = 0
        @patch = 0
      when Vup::SemanticVersions::MINOR
        @minor += 1
        @patch = 0
      when Vup::SemanticVersions::PATCH
        @patch += 1
      end
      self
    end

    def dup
      ProjectVersion.new.tap do |e|
        e.major = @major
        e.minor = @minor
        e.patch = @patch
      end
    end

    def ==(other : ProjectVersion)
      version == other.version
    end
  end
end
