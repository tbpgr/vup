require "../spec_helper"
require "tempfile"

describe Vup::ProjectVersion do
  describe "#load_version_cr" do
    # ::Dir.cd("fixture/single") do
    #   vup = Vup::Up.new(Vup::SemanticVersions::PATCH)
    #   vup.load_version_cr
    #   vup.major.should eq(0)
    #   vup.minor.should eq(1)
    #   vup.patch.should eq(2)
    #   vup.cr_version.should eq("0.1.2")
    # end
  end
end
