module OmniauthMacros
  def mock_auth_hash
    # OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new({
    #   'provider' => 'twitter',
    #   'uid' => '123545',
    #   'info' => {
    #     'name' => 'testuser'
    #   }
    # })
    # OmniAuth.config.add_mock(:facebook, { info: { mail: 'abc@abc.ru' } })

    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
      'provider' => 'facebook',
      'uid' => '123545',
      'info' => {
        'email' => 'abc@abc.ru'
      }
    })

    OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => {
        'name' => 'testuser'
      }
    })

  end
end
