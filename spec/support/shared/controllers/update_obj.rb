shared_examples_for 'PATCH #update' do
  before { sign_in user }

  it 'assign new obg to var' do
    update_path(attributes_for("#{obj.class.name.downcase.to_sym}"))
    expect(assigns(obj.class.name.downcase)).to eq obj
  end

  it "update obj's body" do
    update_path({ body: 'New body' })
    obj.reload
    expect(obj.body).to eq 'New body'
  end

  it "render update's template" do
    update_path(attributes_for("#{obj.class.name.downcase.to_sym}"))
    expect(response).to render_template :update
  end
end
