class SearchController < ApplicationController
  def index
    ThinkingSphinx.search params[:query], classes: [params[:search]] if ['question', 'answer', 'user', 'comment'].include?(params[:search])
    ThinkingSphinx.search params[:query] if params[:search] == 'thinking_sphinx'
  end
end
