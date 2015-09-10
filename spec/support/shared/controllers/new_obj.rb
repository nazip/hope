shared_examples_for 'GET #new' do
  context 'authenticated user can create obj' do
    sign_in_user
    before { new_path }

    it 'assign new obj to var' do
      expect(assigns(obj.class.name.downcase)).to be_a_new(obj.class)
    end
    it 'render new view' do
      expect(response).to render_template :new
    end
  end
  context 'non authenticated user can NOT create obj' do
    before { new_path }

    it 'render the log_in view' do
      expect(response).to redirect_to :user_session
    end
  end
end
