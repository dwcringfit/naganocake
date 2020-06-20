require 'test_helper'

class Client::DeliveriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get client_deliveries_index_url
    assert_response :success
  end

  test "should get create" do
    get client_deliveries_create_url
    assert_response :success
  end

  test "should get edit" do
    get client_deliveries_edit_url
    assert_response :success
  end

  test "should get update" do
    get client_deliveries_update_url
    assert_response :success
  end

  test "should get destroy" do
    get client_deliveries_destroy_url
    assert_response :success
  end

end
