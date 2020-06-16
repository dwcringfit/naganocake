require 'test_helper'

class Client::TopControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get client_top_top_url
    assert_response :success
  end

end
