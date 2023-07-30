require "spec_helper"
require "fiveman/engine"
require "fiveman/export"

describe "Fiveman::Export::Base", :fakefs do
  let(:procfile) { FileUtils.mkdir_p("/tmp/app"); write_procfile("/tmp/app/Procfile") }
  let(:location) { "/tmp/init" }
  let(:engine)   { Fiveman::Engine.new().load_procfile(procfile) }
  let(:subject)  { Fiveman::Export::Base.new(location, engine) }

  it "has a say method for displaying info" do
    expect(subject).to receive(:puts).with("[fiveman export] foo")
    subject.send(:say, "foo")
  end

  it "raises errors as a Fiveman::Export::Exception" do
    expect { subject.send(:error, "foo") }.to raise_error(Fiveman::Export::Exception, "foo")
  end
end
