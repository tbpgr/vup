require "./spec_helper"
require "tempfile"

describe Vup::Up do
  describe "#version" do
    kases = [
      { case: "nil" ,input: nil, expected: Vup::Up::SemanticVersions::PATCH },
      { case: "patch" ,input: Vup::Up::SemanticVersions::PATCH, expected: Vup::Up::SemanticVersions::PATCH },
      { case: "minor" ,input: Vup::Up::SemanticVersions::MINOR, expected: Vup::Up::SemanticVersions::MINOR },
      { case: "major" ,input: Vup::Up::SemanticVersions::MAJOR, expected: Vup::Up::SemanticVersions::MAJOR }
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
          Vup::Up.new(Vup::Up::SemanticVersions::PATCH).validate_single_version
          fail("version.cr が0ファイルの場合は例外が発生する")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("version.cr が1ファイルのみではありません")
        end
      end
    end

    context("double") do
      ::Dir.cd("fixture/double") do
        begin
          Vup::Up.new(Vup::Up::SemanticVersions::PATCH).validate_single_version
          fail("version.cr が複数ファイル存在する場合は例外が発生しなければならない")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("version.cr が1ファイルのみではありません")
        end
      end
    end

    context("single") do
      ::Dir.cd("fixture/single") do
        begin
          Vup::Up.new(Vup::Up::SemanticVersions::PATCH).validate_single_version
          true.should be_true
        rescue e : Exception
          fail("version.cr が1ファイルの場合は例外が発生しない")
        end
      end
    end
  end

  describe "#load_version_cr" do
    ::Dir.cd("fixture/single") do
      vup = Vup::Up.new(Vup::Up::SemanticVersions::PATCH)
      vup.load_version_cr
      vup.major.should eq(0)
      vup.minor.should eq(1)
      vup.patch.should eq(2)
      vup.cr_version.should eq("0.1.2")
    end
  end

  describe "#validate_shard_version" do
    context("not_exist") do
      ::Dir.cd("fixture/not_exist") do
        begin
          Vup::Up.new(Vup::Up::SemanticVersions::PATCH).validate_shard_version
          fail("shard.yml が0ファイルの場合は例外が発生する")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("shard.yml が1ファイルのみではありません")
        end
      end
    end

    context("exist") do
      ::Dir.cd("fixture/single") do
        begin
          Vup::Up.new(Vup::Up::SemanticVersions::PATCH).validate_shard_version
          true.should be_true
        rescue e : Exception
          fail("shard.yml が1ファイルの場合は例外が発生しない")
        end
      end
    end
  end

  describe "#load_shard_yml" do
    ::Dir.cd("fixture/single") do
      vup = Vup::Up.new(Vup::Up::SemanticVersions::PATCH)
      vup.load_shard_yml
      vup.yml_version.should eq("0.1.2")
    end
  end

  describe "#validate_match_versions" do
    context("unmatch") do
      ::Dir.cd("fixture/unmatch") do
        begin
          vup = Vup::Up.new(Vup::Up::SemanticVersions::PATCH)
          vup.load_version_cr
          vup.load_shard_yml
          vup.validate_match_versions
          fail("version.cr の version と shard.yml の version が一致しない場合は例外が発生する")
        rescue e : Exception
          e.class.should eq(Exception)
          e.message.should eq("version.cr の version と shard.yml の version が一致していません")
        end
      end
    end

    context("match") do
      ::Dir.cd("fixture/single") do
        begin
          vup = Vup::Up.new(Vup::Up::SemanticVersions::PATCH)
          vup.load_version_cr
          vup.load_shard_yml
          vup.validate_match_versions
          true.should be_true
        rescue e : Exception
          fail("version.cr の version と shard.yml の version が一致している場合は例外が発生しない")
        end
      end
    end

    describe "#version" do
      kases = [
        { case: "nil" ,input: nil, expected: "0.1.3" },
        { case: "patch" ,input: Vup::Up::SemanticVersions::PATCH, expected: "0.1.3" },
        { case: "minor" ,input: Vup::Up::SemanticVersions::MINOR, expected: "0.2.0" },
        { case: "major" ,input: Vup::Up::SemanticVersions::MAJOR, expected: "1.0.0" }
      ]

      kases.each do |k|
        ::Dir.cd("fixture/single") do
          vup = k[:input].nil? ? Vup::Up.new : Vup::Up.new(k[:input])
          vup.load_version_cr
          vup.load_shard_yml
          actual = vup.bumpup_version
          actual.should eq(k[:expected])
        end
      end
    end
  end
end
