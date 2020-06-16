class Client::ClientsController < Client::Base
  def show
    @client = Client.find(params[:id])
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to client_path(@client)
    else
      render 'edit'
    end
  end

  def confirm_cancel
    @client = Client.find(params[:id])
  end

  def cancel
    @client = Client.find(params[:id])
    if @client.update(is_valid: false)
      sign_out current_client
    end
      redirect_to root_path
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
