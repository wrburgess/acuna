require "rails_helper"

describe AwsEventTypes, type: :module do
  it "renders all types" do
    expect(described_class.all).to include "ObjectCreated:CompleteMultipartUpload", described_class::OBJECT_CREATED_COMPLETE_MULTIPART_UPLOAD
  end

  it "renders created types" do
    expect(described_class.created).to include "ObjectCreated:Copy", described_class::OBJECT_CREATED_PUT
  end

  it "renders delete types" do
    expect(described_class.removed).to include "ObjectRemoved:Delete", described_class::OBJECT_REMOVED_DELETE_MARKER_CREATED
  end

  it "renders restore types" do
    expect(described_class.restore).to include "ObjectRestore:Completed", described_class::OBJECT_RESTORE_POST
  end
end
