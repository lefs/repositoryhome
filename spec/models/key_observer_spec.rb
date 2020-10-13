require 'spec_helper'

describe KeyObserver do
  before(:each) do
    @key = stub_model(Key)
    @observer = KeyObserver.instance
  end

  describe '#after_create' do
    it 'should append SSH key to the authorized_keys file' do
      @observer.should_receive(:append_key).and_return(true)
      @observer.after_create(@key)
    end
  end

  describe '#before_update' do
    it 'should update SSH key in the authorized_keys file' do
      @observer.should_receive(:update_key).and_return(true)
      @key.stub(:body_changed?) { true }
      @observer.before_update(@key)
    end
  end

  describe '#before_destroy' do
    it 'should delete SSH key from the authorized_keys file' do
      @observer.should_receive(:delete_key).and_return(true)
      @observer.before_destroy(@key)
    end
  end
end
