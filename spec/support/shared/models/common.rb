shared_examples_for 'common for q/a' do
  it { should have_many(:attachments).dependent(:destroy) }
  it { should have_many(:elects).dependent(:destroy) }
  it { should accept_nested_attributes_for :attachments }
end
