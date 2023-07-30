require "spec_helper"
require "fiveman/export"

describe "Fiveman::Export" do
  subject { Fiveman::Export }

  describe "with a formatter that doesn't declare the appropriate class" do
    it "prints an error" do
      expect(subject).to receive(:require).with("fiveman/export/invalidformatter")
      mock_export_error("Unknown export format: invalidformatter (no class Fiveman::Export::Invalidformatter).") do
        subject.formatter("invalidformatter")
      end
    end
  end

  describe "with an invalid formatter" do

    it "prints an error" do
      mock_export_error("Unknown export format: invalidformatter (unable to load file 'fiveman/export/invalidformatter').") do
        subject.formatter("invalidformatter")
      end
    end
  end
end
