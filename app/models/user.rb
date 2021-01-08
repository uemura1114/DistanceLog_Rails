class User < ApplicationRecord
  #これでpassword属性とpassword_confirmation属性が追加される。
  has_secure_password

  validates :name,
    presence: true,
    uniqueness: true,
    length: { maximum: 16 },
    format: {
      with: /\A[a-z0-9]+\z/,
      message: 'は小文字英数字で入力してください'
    }
  
  validates :password,
    length: { minimum: 4 }

end
