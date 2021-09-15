require 'rails_helper'

describe '[STEP4] 仕上げのテスト' do
  
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:book) { create(:book, user: user) }
  let!(:other_book) { create(:book, user: other_user) }
  
  describe 'アイコンのテスト' do
    
    #*********************************************
    # ヘッダーの各メニューにアイコンを使用している
    #*********************************************
    context 'ヘッダー: ログインしている場合' do
      subject { page }

      before do
        visit new_user_session_path
        fill_in 'user[name]', with: user.name
        fill_in 'user[password]', with: user.password
        click_button 'Log in'
      end

      it 'Homeリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-home'
      end
      it 'Usersリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-users'
      end
      it 'Booksリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-book-open'
      end
      it 'log outリンクのアイコンが表示される' do
        is_expected.to have_selector '.fas.fa-sign-out-alt'
      end
    end
  end
  #**************************************************************************
  # bootstrapを使用して、サイドバーとそれ以外のエリアに分けて表示ができている
  #**************************************************************************
  describe 'グリッドシステムのテスト: container, row, col-md-〇を正しく使えている' do
    subject { page }

    before do
      visit new_user_session_path
      fill_in 'user[name]', with: user.name
      fill_in 'user[password]', with: user.password
      click_button 'Log in'
    end

    it 'ユーザ一覧画面' do
      visit users_path
      is_expected.to have_selector '.container .row .col-md-3'
      is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
    end
    it 'ユーザ詳細画面' do
      visit user_path(user)
      is_expected.to have_selector '.container .row .col-md-3'
      is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
    end
    it '投稿一覧画面' do
      visit books_path
      is_expected.to have_selector '.container .row .col-md-3'
      is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
    end
    it '投稿詳細画面' do
      visit book_path(book)
      is_expected.to have_selector '.container .row .col-md-3'
      is_expected.to have_selector '.container .row .col-md-8.offset-md-1'
    end
  end
end