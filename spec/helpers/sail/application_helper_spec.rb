describe Sail::ApplicationHelper, type: :helper do
  include described_class

  describe "#main_app" do
    subject { main_app }

    it "returns the URL helper for the main application" do
      expect(subject).to respond_to(:root_path)
    end
  end
end
