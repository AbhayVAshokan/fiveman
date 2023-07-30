require "spec_helper"
require "fiveman"

describe Fiveman do

  describe "VERSION" do
    subject { Fiveman::VERSION }
    it { is_expected.to be_a String }
  end

  describe "runner" do
    it "should exist" do
      expect(File.exist?(Fiveman.runner)).to eq(true)
    end
  end
end
