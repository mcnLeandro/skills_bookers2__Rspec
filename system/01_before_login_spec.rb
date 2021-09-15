require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'ヘッダーのテスト: ログインしていない場合' do 
    before do
      visit root_path
    end
    
    #***********************************************************************************
    # 未ログイン時、ヘッダーに"Home", "About", "Sign Up", "Log In"のリンクが表示される
    #***********************************************************************************
    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Bookers'
      end
      it 'Homeリンクが表示される: 左上から1番目のリンクが「Home」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/home/i)
      end
      it 'Aboutリンクが表示される: 左上から2番目のリンクが「About」である' do
        about_link = find_all('a')[2].native.inner_text
        expect(about_link).to match(/about/i)
      end
      it 'sign upリンクが表示される: 左上から3番目のリンクが「sign up」である' do
        signup_link = find_all('a')[3].native.inner_text
        expect(signup_link).to match(/sign up/i)
      end
      it 'loginリンクが表示される: 左上から4番目のリンクが「login」である' do
        login_link = find_all('a')[4].native.inner_text
        expect(login_link).to match(/login/i)
      end
    end
    #***********************************************************************************
    # 未ログイン時、ヘッダーに"Home", "About", "Sign Up", "Log In"のリンクから
    # それぞれ「トップページ」「アバウトページ」「新規登録画面」「ログイン画面」にリダイレクトしている
    # 
    #***********************************************************************************
    context 'リンクの内容を確認' do
      subject { current_path }

      it 'Homeを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.delete(' ')
        home_link.gsub!(/\n/, '')
        click_link home_link
        is_expected.to eq '/'
      end
      it 'Aboutを押すと、アバウト画面に遷移する' do
        about_link = find_all('a')[2].native.inner_text
        about_link = about_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link about_link
        is_expected.to eq '/home/about'
      end
      it 'sign upを押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[3].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link
        is_expected.to eq '/users/sign_up'
      end
      it 'loginを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[4].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link
        is_expected.to eq '/users/sign_in'
      end
    end
  end
  #***********************************************************
  # ログインしていない場合、ユーザー一覧画面にアクセスできない
  # ログインしていない場合、ユーザー詳細画面にアクセスできない
  # ログインしていない場合、ユーザー編集画面にアクセスできない
  # ログインしていない場合、本一覧画面にアクセスできない
  # ログインしていない場合、本詳細画面にアクセスできない
  #***********************************************************
  describe 'アクセス制限のテスト: アクセスできず、ログイン画面に遷移する' do
    subject { current_path }

    it 'ユーザ一覧画面' do
      visit users_path
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ詳細画面' do
      visit user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it 'ユーザ情報編集画面' do
      visit edit_user_path(user)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿一覧画面' do
      visit books_path
      is_expected.to eq '/users/sign_in'
    end
    it '投稿詳細画面' do
      visit book_path(book)
      is_expected.to eq '/users/sign_in'
    end
    it '投稿編集画面' do
      visit edit_book_path(book)
      is_expected.to eq '/users/sign_in'
    end
  end
  
end