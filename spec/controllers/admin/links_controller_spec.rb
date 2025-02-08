require 'rails_helper'

describe Admin::LinksController, type: :controller do
  include_context 'controller_setup'

  let(:resource) { described_class.controller_name.singularize.to_sym }
  let(:resource_class) { described_class.controller_name.classify.constantize }
  let(:resources) { described_class.controller_name.pluralize.to_sym }

  before do
    sign_in(user)
  end

  describe '#index' do
    before do
      create_list(resource, 3)
    end

    it 'renders the index view' do
      get :index
      expect(response).to render_template(:index)
      expect(response).to have_http_status(:ok)
      expect(assigns(:instances)).to be_present
    end
  end

  describe '#new' do
    it 'renders the new view' do
      get :new

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:new)
      expect(assigns(:instance)).to be_a_new(resource_class)
    end
  end

  describe '#create' do
    let(:instance_params) { attributes_for(resource) }

    it 'creates a new instance' do
      expect do
        post :create, params: { resource => instance_params }
      end.to change(resource_class, :count).by(1)

      instance = resource_class.last
      expect(response).to have_http_status(:redirect)
      expect(flash[:success]).to be_present
      expect(response).to redirect_to(polymorphic_path([:admin, instance]))
    end
  end

  describe '#edit' do
    it 'renders the edit view' do
      instance = create(resource)
      get :edit, params: { id: instance.id }

      expect(response).to have_http_status(:ok)
      expect(response).to render_template(:edit)
      expect(assigns(:instance)).to eq(instance)
    end
  end

  describe '#update' do
    first_url = Faker::Internet.url
    let(:instance) { create(resource, url: first_url) }

    it 'updates the specified instance' do
      second_url = Faker::Internet.url

      expect do
        put :update, params: { id: instance.id, resource => { url: second_url } }
        instance.reload
      end.to change(instance, :url).from(first_url).to(second_url)
    end

    it 'redirects to the updated instance show view' do
      second_url = Faker::Internet.url

      put :update, params: { id: instance.id, resource => { url: second_url } }
      expect(response).to redirect_to(polymorphic_path([:admin, instance]))
    end
  end

  describe '#destroy' do
    let(:instance) { create(resource) }

    it 'destroys an instance' do
      instance # instantiate instance for count

      expect do
        delete :destroy, params: { id: instance.id }
      end.to change(resource_class, :count).by(-1)
    end

    it 'redirects to the instance index view' do
      delete :destroy, params: { id: instance.id }
      expect(response).to redirect_to(polymorphic_path([:admin, resource_class]))
    end
  end

  describe '#archive' do
    let(:instance) { create(resource) }

    it 'archives an instance' do
      expect do
        put :archive, params: { id: instance.id }
      end.to change { instance.reload.archived_at }.from(nil).to(be_present)
    end

    it 'redirects to the instance index view' do
      put :archive, params: { id: instance.id }
      expect(response).to redirect_to(polymorphic_path([:admin, klass]))
    end
  end

  describe '#unarchive' do
    archive_date = 1.minute.ago.beginning_of_minute
    let(:instance) { create(resource, archived_at: archive_date) }

    it 'unarchives an instance' do
      expect do
        get :unarchive, params: { id: instance.id }
      end.to change { instance.reload.archived_at }.from(archive_date).to(nil)
    end

    it 'redirects to the unarchived instance show view' do
      get :unarchive, params: { id: instance.id }
      expect(response).to redirect_to(polymorphic_path([:admin, instance]))
    end
  end

  describe '#collection_export_xlsx' do
    let(:instance) { create(resource) }

    it 'exports a file of a list of instances' do
      get :collection_export_xlsx

      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Disposition']).to match(/#{instance.class_name_plural}_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}\.xlsx/)
      expect(response.headers['Content-Disposition']).to include('attachment')
      expect(response.headers['Content-Type']).to eq('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    end
  end

  describe '#member_export_xlsx' do
    let(:instance) { create(resource) }

    it 'exports a file of an instance' do
      get :member_export_xlsx, params: { id: instance.id }

      expect(response).to have_http_status(:ok)
      expect(response.headers['Content-Disposition']).to match(/#{instance.class_name_singular}_\d{4}-\d{2}-\d{2}_\d{2}-\d{2}-\d{2}\.xlsx/)
      expect(response.headers['Content-Disposition']).to include('attachment')
      expect(response.headers['Content-Type']).to eq('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')
    end
  end
end
