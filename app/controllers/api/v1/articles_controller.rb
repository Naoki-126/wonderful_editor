module Api::V1
  # base_api_controllerを継承
  class ArticlesController < BaseApiController
    def index
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      # binding.pry
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end
  end
end
