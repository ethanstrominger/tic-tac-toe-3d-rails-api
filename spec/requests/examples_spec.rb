# frozen_string_literal: true

require 'rails_helper'

require 'auth_helper'

# require 'debug_helper'
# include DebugHelper

RSpec.configure do |c|
  c.include AuthHelper
end

RSpec.describe 'Examples', type: :request do
  before(:all) do
    Example.delete_all
    User.delete_all
    signup_and_in
  end

  after(:all) do
    Example.delete_all
    User.delete_all
  end
  sample_date = '2020-12-25'
  example_params1 = { text: 'Text 1 example' }
  example_params2 = { text: 'Text 2 example'}
  example_params3 = { text: 'Text 3 example' }
  create_values = { text: 'Text for create test' }

  def examples
    Example.all
  end

  def get_example_first
    Example.first
  end

  def get_example_last
    Example.last
  end

  before(:all) do
    signup_and_in
    post '/examples', params: { example: example_params1 }, headers: headers
    post '/examples', params: { example: example_params2 }, headers: headers
    post '/examples', params: { example: example_params3 }, headers: headers
  end

  after(:all) do
    Example.delete_all
  end

  describe 'GET /examples' do
    it 'lists all examples' do
      get '/examples', headers: headers
      expect(response).to be_success
      examples_response = JSON.parse(response.body)
      expect(examples_response["examples"].length).to eq(examples.count)
      expect(examples_response["examples"].first['title']).to eq(get_example_first['title'])
    end
  end

  describe 'GET /examples/:id' do
    it 'shows one example' do
      example_id = get_example_first['id']
      get "/examples/#{example_id}", headers: headers
      expect(response).to be_successful

      json_response = JSON.parse(response.body)
      example_response = json_response['example']

      expect(example_response['id']).not_to be_nil
      expect(example_response['title']).to eq(get_example_first['title'])
    end
  end

  describe 'DELETE /examples/:id' do
    it 'deletes an example' do
      last_id = get_example_last['id']
      delete "/examples/#{last_id}", headers: headers
      expect(response).to be_successful
      example_exists = Example.exists?(last_id)
      expect(example_exists).to eq(false)
    end
  end

  describe 'PATCH /examples/:id' do
    update_example = { text: 'Updated example, only text updated' }
    

    it 'updates an example' do
      last_id = get_example_last['id']
      patch "/examples/#{last_id}",
         params: { example: update_example },
         headers: headers
      expect(response).to be_successful
    end
  end

  describe 'POST /examples' do
    it 'creates an example' do
      post '/examples', params: { example: create_values }, headers: headers
      expect(response).to be_successful
      last_record = Example.last
      expect(last_record['title']).to eq(create_values[:title])
    end
  end
end
