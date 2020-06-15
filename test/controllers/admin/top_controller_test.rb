require 'test_helper'

class Admin::TopControllerTest < ActionDispatch::IntegrationTest
  test "should get top" do
    get admin_top_top_url
    assert_response :success
  end

end
