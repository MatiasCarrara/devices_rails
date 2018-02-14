class DevicesController < ApplicationController
  def index
    @device = Device.all
  end

  def show
    @device = Device.find(params[:id])
  end

  def new
    @device = Device.new
  end

  def edit
    @device = Device.find(params[:id])
  end

  def create
    @device = Device.new(device_params)

    if @device.save
      redirect_to @device
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def update
    @device = Device.find(params[:id])

    if @device.update(device_params)
      redirect_to @device
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @device = Device.find(params[:id])
    @device.destroy

    redirect_to devices_path
  end

  private
    def device_params
      params.require(:device).permit(:name, :address)
    end

end
