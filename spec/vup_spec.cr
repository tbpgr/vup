require "./spec_helper"
require "tempfile"

describe Vup::Up do
  kases = [
    { case: "nil" ,input: nil, expected: Vup::Up::SemanticVersions::PATCH },
    { case: "patch" ,input: Vup::Up::SemanticVersions::PATCH, expected: Vup::Up::SemanticVersions::PATCH },
    { case: "minor" ,input: Vup::Up::SemanticVersions::MINOR, expected: Vup::Up::SemanticVersions::MINOR },
    { case: "major" ,input: Vup::Up::SemanticVersions::MAJOR, expected: Vup::Up::SemanticVersions::MAJOR }
  ]

# テスト時はファイルの書き込みを検証しないでいいや

  kases.each do |k|
    describe "#version" do
      it k[:case] do
        actual = k[:input].nil? ? Vup::Up.new : Vup::Up.new(k[:input])
        actual.version.should eq(k[:expected])
      end
    end

    describe "#read_version_cr" do
      ::Dir.cd("fixture") do
        
      end
    end
  end
end
