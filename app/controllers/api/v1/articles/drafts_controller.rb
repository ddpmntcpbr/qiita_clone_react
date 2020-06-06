class Api::V1::Articles::DraftsController < Api::V1::ApiController
  before_action :authenticate_user!, only: [:index, :show]

  def index
    articles = current_user.articles.draft.order(created_at: :desc)
    render json: articles
  end

  def show
    articles = current_user.articles.draft.find(params[:id])
    render json: articles
  end
end
