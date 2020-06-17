require 'test_helper'

class Client::ItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get client_items_index_url
    assert_response :success
  end

  test "should get show" do
    get client_items_show_url
    assert_response :success
  end

end
