shared_examples_for "should return success" do
  it 'return success (200)' do
    expect(response).to be_success
  end
end