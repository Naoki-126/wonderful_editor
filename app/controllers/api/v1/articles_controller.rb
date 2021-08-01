module Api::V1
  # base_api_controllerを継承
  class ArticlesController < BaseApiController
    # before_action :authenticate_user!, only: [:create]

    def index
      articles = Article.order(updated_at: :desc)
      render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
    end

    def show
      article = Article.find(params[:id])
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def create
      # インスタンスをmodelから作成する
      # インスタンスをDBに保存する falseでなくerrorで返せる様に'！'をつける
      article = current_user.articles.create!(article_params)
      # jsonとして返す
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    def update
      # 対象のレコードを探す
      article = current_user.articles.find(params[:id])
      # 探してきたレコードに対して変更を行う
      article.update!(article_params)
      # jsonとして値を返す
      render json: article, serializer: Api::V1::ArticleSerializer
    end

    private

      def article_params
        params.require(:article).permit(:title, :body)
      end
  end
end
