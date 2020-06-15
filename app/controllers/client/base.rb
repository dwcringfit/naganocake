# 顧客用ECサイト ApplicationController
class Client::Base < ApplicationController

  protected

  def devise_parameter_sanitizer
    if resource_class == Client
      Client::ParameterSanitizer.new(Client, :client, params)
    else
      super
    end
  end
end
