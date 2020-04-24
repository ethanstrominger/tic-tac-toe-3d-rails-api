module AuthHelper
  def headers
    {
      'HTTP_AUTHORIZATION' => "Token token=#{@token}"
    }
  end

  def user_id
    @user_id
  end

  def user_params
    {
      email: 'alice@example.com',
      password: 'foobarbaz',
      password_confirmation: 'foobarbaz'
    }
  end

  def signup_and_in
    post '/sign-up', params: { credentials: user_params }
    post '/sign-in', params: { credentials: user_params }

    @token = JSON.parse(response.body)['user']['token']
    @user_id = JSON.parse(response.body)['user']['id']
  end
end
