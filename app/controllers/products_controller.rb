class ProductsController < RankingController
  before_action :authenticate_user!, only: [:search,:index]

  def index
    @products = Product.order('id asc').limit 20
  end

  def show
    @product = Product.find params[:id]
  end

  def search
    @products = Product.where('title LIKE(?)', "%#{params[:keyword]}%")
  end
end
