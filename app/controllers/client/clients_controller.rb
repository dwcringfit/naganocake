class Client::ClientsController < Client::Base
  before_action :set_client

  def show
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to client_path(@client)
    else
      render 'edit'
    end
  end

  def confirm_cancel
  end

  def cancel
    if @client.update(is_valid: false)
      sign_out current_client
    end
      redirect_to root_path
  end

  def set_client
    @client = Client.find(params[:id])
  end

    private
    def client_params
      params.require(:client).permit(:is_valid, :first_name, :family_name, :first_name_kana, :family_name_kana, :tel, :email, :password, :post_number, :address)
    end

    def ensure_correct_client
      @client = Client.find(params[:id])
      if current_client.id != @client.id
        redirect_to root_path
      end
    end
end
