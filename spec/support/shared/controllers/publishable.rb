shared_examples_for 'Publishable' do
  it 'with valid object' do
    expect(PrivatePub).to receive(:publish_to).with(request_path, anything)
    request
  end
  it 'with invalid object' do
    expect(PrivatePub).to_not receive(:publish_to)
    bad_request
  end
end