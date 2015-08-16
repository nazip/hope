module OmniauthMacros
  def mock_auth_hash
    OmniAuth.config.mock_auth[:default] = OmniAuth::AuthHash.new({
      'provider' => 'twitter',
      'uid' => '123545',
      'info' => {
        'name' => 'testuser'
      }
    })
    OmniAuth.config.add_mock(:facebook, { info: { mail: 'abc@abc.ru' } })
  end
end
