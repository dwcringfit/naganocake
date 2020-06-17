require 'test_helper'

class Client::ClientsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get client_clients_show_url
    assert_response :success
  end

  test "should get edit" do
    get client_clients_edit_url
    assert_response :success
  end

  test "should get update" do
    get client_clients_update_url
    assert_response :success
  end

  test "should get confirm_cancel" do
    get client_clients_confirm_cancel_url
    assert_response :success
  end

  test "should get cancel" do
    get client_clients_cancel_url
    assert_response :success
  end

end
