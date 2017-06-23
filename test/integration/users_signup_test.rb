# coding: utf-8
require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    # メッセージ数をクリア
    ActionMailer::Base.deliveries.clear
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: {user: {name: "",
                                       email: "user@invalid",
                                       password: "foo",
                                       password_confirmation: "bar"}}
    end
    # POSTした後がusers/newとなっていることを確認
    assert_template 'users/new'

    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    # assert_select 'form[action=?]', signup_path
    assert_select 'form[action="/signup"]'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {user: {name: "Example User",
                                       email: "user@example.com",
                                       password: "password",
                                       password_confirmation: "password"}}
    end
    # メッセージが送信されていることの確認
    assert_equal 1, ActionMailer::Base.deliveries.size
    # assignsはこのファイルに対応するコントローラではなく、
    # この辞典で対応するコントローラのインスタンス変数へアクセスできる。
    # (この場合はpost signup_pathなのでUsersController#create内の@user)
    user = assigns(:user)
    assert_not user.activated?
    # 有効化していない状態でログイン
    log_in_as(user)
    assert_not is_logged_in?
    # 不正なトークン
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # 不正なアドレス
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 正しいトークンとアドレス
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
