class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  protect_from_forgery with: :exception
  before_action :authenticate_admin, if: :in_admin_namespace?
  

  private

  def authenticate_admin
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["HTTP_BASIC_USER"] && password == ENV["HTTP_BASIC_PASSWORD"]
    end
  end

  def in_admin_namespace?
    controller_path.start_with?("admin/")
  end
  helper_method :in_admin_namespace?  # Make the helper method available to views

  def cart
    @cart ||= cookies[:cart].present? ? JSON.parse(cookies[:cart]) : {}
  end
  helper_method :cart

  def enhanced_cart
    @enhanced_cart ||= Product.where(id: cart.keys).map {|product| { product:product, quantity: cart[product.id.to_s] } }
  end
  helper_method :enhanced_cart

  def cart_subtotal_cents
    enhanced_cart.map {|entry| entry[:product].price_cents * entry[:quantity]}.sum
  end
  helper_method :cart_subtotal_cents


  def update_cart(new_cart)
    cookies[:cart] = {
      value: JSON.generate(new_cart),
      expires: 10.days.from_now
    }
    cookies[:cart]
  end
end
