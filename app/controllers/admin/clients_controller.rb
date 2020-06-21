class Admin::ClientsController < Admin::Base
before_action :set_client, only:[:show, :edit, :update]
  def index
    @clients = Client.page(params[:page]).per(10)
  end

  def show
  end

  def edit
  end

  def update
    if @client.update(client_params)
      redirect_to admin_client_path
    else
      render 'edit'
    end
  end

  def set_client
    @client = Client.find(params[:id])
  end

  private
  def client_params
    params.require(:client).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :post_number, :address, :tel, :email, :is_valid)
  end
end