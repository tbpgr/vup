require "../src/vup"
require "option_parser"

begin
  version = Vup::Up::SemanticVersions::PATCH
  OptionParser.parse! do |parser|
    parser.banner = "Usage: vup"
    parser.on("-v", "--version", "Show version") { puts Vup::VERSION; exit 0 }
    parser.on("-ma", "--major", "major version up") {
      version = Vup::Up::SemanticVersions::MAJOR
    }
    parser.on("-mi", "--minor", "minor version up") {
      version = Vup::Up::SemanticVersions::MINOR
    }
    parser.on("-p", "--patch", "patch version up") {
      version = Vup::Up::SemanticVersions::PATCH
    }
    parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }
  end

  Vup::Up.new(version).bumpup_files
  exit 0
rescue e
  STDERR.puts e
  exit 1
end
