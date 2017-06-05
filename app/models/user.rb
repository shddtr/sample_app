# coding: utf-8
class User < ApplicationRecord
  # Userモデルの中では右式のselfを省略できる
  # before_save {self.email = email.downcase}
  before_save {self.email.downcase!}
  validates :name, presence: true, length: {maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX},
            uniqueness: {case_sensitive: false}
  has_secure_password
  # has_secure_passwordもpresenceの検査を行うが
  # レコードの追加時のみ行うため、以下が必要
  validates :password, presence: true, length: {minimum: 6}
end
