class Product < ActiveRecord::Base
  validates :title, :user_id, presence: true
  validates :price, presence: true,
    numericality: { greater_than_or_equal_to: 0 }

  belongs_to :user

  scope :filter_by_title, ->(keyword) { where("lower(title) LIKE ?", "%#{keyword.downcase}%") }
  scope :above_or_equal_to_price, ->(price) { where("price >= ?", price) }
  scope :below_or_equal_to_price, ->(price) { where("price <= ?", price) }
  scope :recent, -> { order(:updated_at) }

  def self.search(params={})
    products = all
    products = products.find(params[:product_ids]) if params[:product_ids]
    products = products.filter_by_title(params[:keyword]) if params[:keyword]
    products = products.below_or_equal_to_price(params[:max_price]) if params[:max_price]
    products = products.above_or_equal_to_price(params[:min_price]) if params[:min_price]
    products
  end
end
