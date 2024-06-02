class DevicesController < ApplicationController
  before_action :authenticate_user!

  def index
    @devices = current_user.devices
    @device = Device.new
  end

  def show
    @device = current_user.devices.find(params[:id])
  end

  def new
    @device = Device.new
  end

  def create
    @device = current_user.devices.new(device_params)
    if @device.save
      bind_device_to_adafruit_io(@device)
      redirect_to devices_path, notice: 'Device was successfully added.'
    else
      @devices = current_user.devices
      render :index
    end
  end

  def edit
    @device = current_user.devices.find(params[:id])
  end

  def update
    @device = current_user.devices.find(params[:id])
    if @device.update(device_params)
      redirect_to devices_path, notice: 'Device was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @device = current_user.devices.find(params[:id])
    unbind_device_from_adafruit_io(@device)
    @device.destroy
    redirect_to devices_path, notice: 'Device was successfully removed.'
  end

  def toggle_state
    @device = current_user.devices.find(params[:id])
    new_state = @device.state == "on" ? "off" : "on"
    @device.update(state: new_state)
    send_to_adafruit_io(@device)
    redirect_to @device
  end

  private

  def device_params
    params.require(:device).permit(:name, :mac_address, :state)
  end

  def bind_device_to_adafruit_io(device)
    require 'rest-client'

    api_url = "https://io.adafruit.com/api/v2/QueXu/feeds"
    api_key = "aio_prGk59hr3knUASMLeSOEDD9kpHJx"

    payload = {
      feed: {
        name: device.mac_address,
        description: device.name
      }
    }

    headers = {
      'X-AIO-Key': api_key,
      content_type: :json,
      accept: :json
    }

    response = RestClient.post(api_url, payload.to_json, headers)
    json_response = JSON.parse(response.body)
    device.update(feed_id: json_response['id'])
  end

  def unbind_device_from_adafruit_io(device)
    require 'rest-client'

    api_url = "https://io.adafruit.com/api/v2/QueXu/feeds/#{device.feed_id}"
    api_key = "aio_prGk59hr3knUASMLeSOEDD9kpHJx"

    headers = {
      'X-AIO-Key': api_key,
      content_type: :json,
      accept: :json
    }

    RestClient.delete(api_url, headers)
  end

  def send_to_adafruit_io(device)
    require 'rest-client'

    api_url = "https://io.adafruit.com/api/v2/QueXu/feeds/#{device.feed_id}/data"
    api_key = "aio_prGk59hr3knUASMLeSOEDD9kpHJx"
    value = device.state == "on" ? "ON" : "OFF"

    payload = {
      value: value
    }

    headers = {
      'X-AIO-Key': api_key,
      content_type: :json,
      accept: :json
    }

    RestClient.post(api_url, payload.to_json, headers)
  end
end
