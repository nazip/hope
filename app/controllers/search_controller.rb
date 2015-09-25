class SearchController < ApplicationController

  def index
# binding.pry
    @search = ThinkingSphinx.search params[:query], classes: [params[:search].classify.constantize] if ['question', 'answer', 'user', 'comment'].include?(params[:search])
    @search = ThinkingSphinx.search(params[:query]) if params[:search] == 'thinking_sphinx'
  end
end
