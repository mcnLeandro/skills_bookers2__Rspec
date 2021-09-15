require 'rails_helper'

describe '[STEP2] ログイン機能のテスト' do
  describe 'ユーザ新規登録のテスト' do
    
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'Sign up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'Sign up'
      end
    end
    
    #****************************************************
    # 必要情報に全て入力されている時、新規登録に成功する
    #****************************************************
    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button 'Sign up' }.to change(User.all, :count).by(1)
      end
    end
    #********************************************************
    # 必要情報が入力されていない場合、新規登録に失敗する
    #********************************************************
    context '新規登録失敗のテスト' do
      before do
        visit new_user_registration_path
        fill_in 'user[name]', with: ''
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '新規登録されない' do
        expect { click_button 'Sign up' }.not_to change(User.all, :count)
      end
    end
  end
  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「Log in」と表示される' do
        expect(page).to have_content 'Log in'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Log inボタンが表示される' do
        expect(page).to have_button 'Log in'
      end
      it 'emailフォームは表示されない' do
        expect(page).not_to have_field 'user[email]'
      end
    end
    
    #**********************************************
    # ユーザー名とパスワードでログインができる  
    #**********************************************
    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
      end

      it 'ログインに成功する' do
        expect(current_path).not_to eq '/users/sign_in'
      end
    end
    #**************************************************************************
    # ユーザー名とパスワードが空欄、もしくは誤っている場合にログインが失敗する
    #**************************************************************************
    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[name]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Log in'
      end

      it 'ログインに失敗する' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end