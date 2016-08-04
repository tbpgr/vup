require "../spec_helper"
require "tempfile"

describe Vup::Up do
  describe "#version" do
    kases = [
      { case: "nil" ,input: nil, expected: Vup::SemanticVersions::PATCH },
      { case: "patch" ,input: Vup::SemanticVersions::PATCH, expected: Vup::SemanticVersions::PATCH },
      { case: "minor" ,input: Vup::SemanticVersions::MINOR, expected: Vup::SemanticVersions::MINOR },
      { case: "major" ,input: Vup::SemanticVersions::MAJOR, expected: Vup::SemanticVersions::MAJOR }
    ]

    kases.each do |k|
      it k[:case] do
        actual = k[:input].nil? ? Vup::Up.new : Vup::Up.new(k[:input])
        actual.version.should eq(k[:expected])
      end
    end
  end

  describe "#validate_single_version" do
    context("not_exist") do
      ::Dir.cd("fixture/not_exist") do
        begin
          Vup::Up.new(Vup::SemanticVersions::PATCH).validate_single_version
          fail("error")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("Invalid count(version.cr : 0)")
        end
      end
    end

    context("double") do
      ::Dir.cd("fixture/double") do
        begin
          Vup::Up.new(Vup::SemanticVersions::PATCH).validate_single_version
          fail("error")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("Invalid count(version.cr : 2)")
        end
      end
    end

    context("single") do
      ::Dir.cd("fixture/single") do
        begin
          Vup::Up.new(Vup::SemanticVersions::PATCH).validate_single_version
          true.should be_true
        rescue e : Exception
          fail("error")
        end
      end
    end
  end

  describe "#validate_shard_version" do
    context("not_exist") do
      ::Dir.cd("fixture/not_exist") do
        begin
          Vup::Up.new(Vup::SemanticVersions::PATCH).validate_shard_version
          fail("error")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("Invalid count(shard.yml : 0)")
        end
      end
    end

    context("exist") do
      ::Dir.cd("fixture/single") do
        begin
          Vup::Up.new(Vup::SemanticVersions::PATCH).validate_shard_version
          true.should be_true
        rescue e : Exception
          fail("error")
        end
      end
    end
  end

  describe "#load_shard_yml" do
    ::Dir.cd("fixture/single") do
      vup = Vup::Up.new(Vup::SemanticVersions::PATCH)
      vup.load_shard_yml
      vup.yml_version.version.should eq("0.1.2")
    end
  end

  describe "#validate_match_versions" do
    context("unmatch") do
      ::Dir.cd("fixture/unmatch") do
        begin
          vup = Vup::Up.new(Vup::SemanticVersions::PATCH)
          vup.load_version_cr
          vup.load_shard_yml
          vup.validate_match_versions
          fail("error")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("version.cr version != shard.yml version")
        end
      end
    end

    context("match") do
      ::Dir.cd("fixture/single") do
        begin
          vup = Vup::Up.new(Vup::SemanticVersions::PATCH)
          vup.load_version_cr
          vup.load_shard_yml
          vup.validate_match_versions
          true.should be_true
        rescue e : Exception
          fail("error")
        end
      end
    end

    describe "#version" do
      kases = [
        { case: "nil" ,input: nil, expected: "0.1.3" },
        { case: "patch" ,input: Vup::SemanticVersions::PATCH, expected: "0.1.3" },
        { case: "minor" ,input: Vup::SemanticVersions::MINOR, expected: "0.2.0" },
        { case: "major" ,input: Vup::SemanticVersions::MAJOR, expected: "1.0.0" }
      ]

      kases.each do |k|
        ::Dir.cd("fixture/single") do
          vup = k[:input].nil? ? Vup::Up.new : Vup::Up.new(k[:input])
          vup.load_version_cr
          vup.load_shard_yml
          vup.new_version.version.should eq(k[:expected])
        end
      end
    end
  end
end
