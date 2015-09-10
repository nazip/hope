shared_examples_for 'GET #destroy' do
  context 'user can delete his obj' do
    before { sign_in user }

    it 'delete from the table' do
      expect { destroy_path }.to change(obj.class, :count).by(-1)
    end
  end
  context 'user can not delete the obj owned by other user' do
    sign_in_user

    it 'do not delete from the table' do
      expect { destroy_path }.to_not change(obj.class, :count)
    end
  end
end
