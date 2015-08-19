class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :elects
  has_many :authorizations
  validates :email, :password, :password_confirmation, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def elect_for? obj, *election
    if election.size == 0
      self.elects.where(electable: obj).count != 0
    else
      self.elects.where(electable: obj, election: election[0]).count == 0
    end
  end

  def self.find_for_oauth(auth, mail = nil)
    authorization = Authorization.where(provider: auth['provider'], uid: auth['uid']).first;
    return authorization.user if authorization
    auth['info']['email'] = mail unless mail.nil?
    if auth['info']['email'].nil?
      user = User.create
    else
      email = auth['info']['email']
      user = User.where(email: email).first
      if user
        user.authorizations.create(provider: auth['provider'], uid: auth['uid'])
      else
        password = Devise.friendly_token[0, 20]
        user = User.create!(email: email, password: password, password_confirmation: password)
        user.authorizations.create(provider: auth['provider'], uid: auth['uid'])
      end
      user
    end
  end

  def apply_omniauth(auth)
    authorizations.build(provider: auth['provider'], uid: auth['uid'])
  end

  # def password_required?
  #   (authorizations.empty? || !password.blank?) && super
  # end
end
