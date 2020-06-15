class ClientParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    client_params = [
      :first_name,
      :family_name,
      :first_name_kana,
      :family_name_kana,
      :post_number,
      :address,
      :tel
    ]
    default_params.permit(client_params)
  end
end