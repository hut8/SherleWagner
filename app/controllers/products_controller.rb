class ProductsController < ApplicationController
  def upload_product_file
    Product.upload_product_file(params[:filename])

    redirect_to :back
  end

  def show
    @product = Product.find(params[:id])
    @material_types = @product.material_types
    @insert_types = @product.insert_types
    @associated_products = []
    @associated_products = @product.product_group.products
  end

  def index
    @products = []
    products = Product.all
    products.each do |product|
      product.filteroonies = product.filters
      @products << product
    end
  end

end
