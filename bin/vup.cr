require "../src/vup"
require "option_parser"

begin
  version = Vup::SemanticVersions::PATCH
  show = false
  dry_run = false
  detail = false
  OptionParser.parse! do |parser|
    parser.banner = "Usage: vup"
    parser.on("-v", "--version", "Show version") { puts Vup::VERSION; exit 0 }
    parser.on("-ma", "--major", "major version up") { version = Vup::SemanticVersions::MAJOR }
    parser.on("-mi", "--minor", "minor version up") { version = Vup::SemanticVersions::MINOR }
    parser.on("-p", "--patch", "patch version up") { version = Vup::SemanticVersions::PATCH }
    parser.on("--show", "show current version") { show = true }
    parser.on("-d", "--detail", "show update files") { detail = true }
    parser.on("-n", "--dry-run", "show version and files to change without actual change") { dry_run = true }
    parser.on("-h", "--help", "Show this help") { puts parser; exit 0 }
  end

  klass = show ? Vup::Show : Vup::Up
  klass.new(version, dry_run, detail).run
  exit 0
rescue e
  STDERR.puts e
  exit 1
end
