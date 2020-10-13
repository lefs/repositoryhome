require 'spec_helper'

describe SettingsController do
  describe 'routing' do
    it 'routes to #index' do
      get('/settings').should route_to('settings#index')
    end

    it 'routes to #update_user_details' do
      put('/settings').should route_to('settings#update_user_details')
    end

    it 'routes to #create_key' do
      post('/settings/keys').should route_to('settings#create_key')
    end

    it 'routes to #edit_key' do
      get('/settings/keys/1/edit').should route_to('settings#edit_key', id: '1')
    end

    it 'routes to #update_key' do
      put('/settings/keys/1').should route_to('settings#update_key', id: '1')
    end

    it 'routes to #destroy_key' do
      delete('/settings/keys/1').should route_to('settings#destroy_key', id: '1')
    end
  end
end
