require 'rails_helper'

RSpec.describe SearchController, type: :controller do

  describe "GET #index" do
    ['question', 'answer', 'user', 'comment', 'thinking_sphinx'].each do |param|
      it "should execute with param = '#{param}'" do
        expect(ThinkingSphinx).to receive(:search)
        get :index, query: 'abc', search: param
      end
    end
    it 'should execute with bad param' do
      expect(ThinkingSphinx).to_not receive(:search)
      get :index, query: 'abc', search: 'bad param'
    end
  end
end
