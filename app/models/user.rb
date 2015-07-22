class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :elects
  validates :email, :password, :password_confirmation, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def elect_for? obj, *election
    if election.size == 0
      self.elects.where(electable: obj).count != 0
    else
      self.elects.where(electable: obj, election: election[0]).count == 0
    end
  end
end
