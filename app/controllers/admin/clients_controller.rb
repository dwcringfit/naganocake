class Admin::ClientsController < Admin::Base
  before_action :authenticate_admin!

  def index
    @clients = Client.page(params[:page]).per(10)
  end

  def show
    @client = Client.find(params[:id])
  end

  def edit
    @client = Client.find(params[:id])
  end

  def update
    @client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to admin_client_path
    else
      flash[:client_updated_error] = "会員情報が正常に保存されませんでした。"
      redirect_to edit_admin_client_path(@clients)
    end
  end

  private
  def client_params
    params.require(:client).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :post_code, :address, :tel, :email, :is_valid)
  end
end