shared_examples_for 'GET #destroy attachment' do
  it 'deletes attachment' do
    expect do
      obj.attachable_type == 'Question' ? obj_path : obj_path({answer_id: answer})
    end.to change(Attachment, :count).by(-1)
  end
  it 'render the template destroy' do
    obj.attachable_type == 'Question' ? obj_path : obj_path({answer_id: answer})
    expect(response).to render_template 'attachments/destroy'
  end
end
