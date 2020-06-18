require 'test_helper'

class Client::OrdersControllerTest < ActionDispatch::IntegrationTest
  test "should get thanks" do
    get client_orders_thanks_url
    assert_response :success
  end

  test "should get confirm" do
    get client_orders_confirm_url
    assert_response :success
  end

  test "should get index" do
    get client_orders_index_url
    assert_response :success
  end

  test "should get new" do
    get client_orders_new_url
    assert_response :success
  end

  test "should get create" do
    get client_orders_create_url
    assert_response :success
  end

  test "should get show" do
    get client_orders_show_url
    assert_response :success
  end

end
