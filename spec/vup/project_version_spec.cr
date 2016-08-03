require "../spec_helper"
require "tempfile"

describe Vup::ProjectVersion do
  describe "#version" do
    it "returns major.minor.patch" do
      pv = Vup::ProjectVersion.new
      pv.major = 1
      pv.minor = 2
      pv.patch = 3
      pv.version.should eq "1.2.3"
    end
  end

  describe "#bumpup" do
    kases = [
      { case: Vup::SemanticVersions::PATCH, expected: "1.2.4" },
      { case: Vup::SemanticVersions::MINOR, expected: "1.3.0" },
      { case: Vup::SemanticVersions::MAJOR, expected: "2.0.0" }
    ]
    pv = Vup::ProjectVersion.new
    pv.major = 1
    pv.minor = 2
    pv.patch = 3

    kases.each do |k|
      context k[:case] do
        it "equals #{k[:expected]}" do
          pv.dup.bumpup(k[:case]).version.should eq k[:expected]
        end
      end
    end
  end
end
