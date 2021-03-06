require 'rails_helper'

describe DevicesController, type: :controller do
  let(:device_general) { Device }

  describe 'GET #index' do
    let(:devices) { create(:device, :name) }
    before do
      get :index
    end
    it 'status codes' do
      expect(response).to have_http_status(:ok)
    end
    it 'redirect index' do
      expect(response).to render_template(:index)
    end
    it 'get all devices' do
      expect(assigns(:device)).to match_array(devices)
    end
  end

  describe 'GET #new' do
    before do
      get :new
    end
    it 'status codes' do
      expect(response).to have_http_status(:ok)
    end
    it 'redirect show ' do
      expect(response).to render_template(:new)
    end
    it 'assigns a device to Device' do
      expect(assigns(:device)).to be_a(device_general)
    end
  end

  describe 'GET #show' do
    context 'the ID is valid' do
      let(:device) { create(:device, :name) }

      before do
        get :show, params: { id: device }
      end
      it 'redirect show' do
        expect(response).to render_template('show')
      end
      it 'status codes' do
        expect(response).to have_http_status(:ok)
      end
      it '' do
        expect(assigns(:device)).to eq(device)
      end
    end

    context 'the ID is invalid' do
      let(:invalid) { 'id_invalid' }

      before do
        get :show, params: { id: invalid }
      end
      it 'status codes' do
        expect(response).to have_http_status(:not_found)
      end
      it 'redirect to error page' do
        expect(response).to render_template('error')
      end
    end
  end

  describe 'GET #edit' do
    context 'the ID is valid' do
      let(:device) { create(:device, :name) }

      before do
        get :edit, params: { id: device }
      end
      it 'status code' do
        expect(response).to have_http_status(:ok)
      end
      it 'redirect to edit' do
        expect(response).to render_template('edit')
      end
      it 'assigns requested device to Device' do
        expect(assigns(:device)).to eq(device)
      end
    end

    context 'the ID is invalid' do
      let(:invalid) { 'id_invalid' }

      before do
        get :show, params: { id: invalid }
      end
      it 'status code ' do
        expect(response).to have_http_status(:not_found)
      end
      it 'redirect to error page' do
        expect(response).to render_template('error')
      end
    end
  end

  describe 'PUT #update' do
    let(:device) { create(:device, :name) }
    context 'valid parameters' do
      let(:params) { { name: 'ViewSonic', address: 911 } }

      before do
        patch :update, params: { id: device, device: params }
      end
      it 'status code' do
        expect(response).to have_http_status(:found)
      end
      it 'redirects device' do
        expect(:device).to redirect_to(device)
      end
      it 'assigns requested device to Device' do
        expect(assigns(:device)).to eq(device)
      end
      it 'update data' do
        device.reload
        expect(device.name).to eq('ViewSonic')
      end
    end

    context 'invalid parameters' do
      let(:params) { { name: 'ViewSonic', address: nil } }

      before do
        patch :update, params: { id: device, device: params }
      end
      it 'status code' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'redirect to the edit ' do
        expect(response).to render_template('edit')
      end
    end
  end

  describe 'POST #create' do
    context 'valid parameters' do
      let(:valid) { attributes_for(:device, :name) }

      before do
        post :create, params: { device: valid }
      end
      it 'status codes' do
        expect(response).to have_http_status(:found)
      end
      it 'create device' do
        expect { post :create, params: { device: valid } }
          .to change(device_general, :count).by(1)
      end
      it 'redirect to the device' do
        expect(:device).to redirect_to(device_general.last)
      end
    end

    context 'invalid parameters' do
      let(:invalid) { attributes_for(:device, :invalid_name) }

      before do
        post :create, params: { device: invalid }
      end
      it 'status codes' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'not create device ' do
        expect { post :create, params: { device: invalid } }
          .to change(device_general, :count).by(0)
      end
      it 'render template new' do
        expect(response).to render_template('new')
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:device) { create(:device, :name) }
    let(:destroy) { delete :destroy, params: { id: device } }
    it 'status code' do
      destroy
      expect(response).to have_http_status(:found)
    end
    it 'delete device' do
      expect { destroy }
        .to change(device_general, :count).by(-1)
    end
    it 'redirect index' do
      destroy
      expect(response).to redirect_to devices_path
    end
  end
end
