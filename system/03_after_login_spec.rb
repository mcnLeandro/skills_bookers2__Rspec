require 'rails_helper'

describe '[STEP3] ユーザログイン後のテスト' do

  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:book) { create(:book, user: user) }
  let!(:other_book) { create(:book, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[name]', with: user.name
    fill_in 'user[password]', with: user.password
    click_button 'Log in'
  end

  shared_examples 'サイドバーの確認' do

    context 'サイドバーの確認' do
      #************************************
      # 画像、名前、自己紹介が表示される
      #************************************
      it '自分の画像、名前、紹介文が表示される' do
        #上でimage付きで保存して、それを確かめる記述を追加する。
        # expect(page).to have_
        expect(page).to have_content user.name
        expect(page).to have_content user.introduction
      end
      #********************************************************************
      # 他人のユーザー情報画面を開いている時以外は、編集リンクが表示される
      #********************************************************************
      it '自分のユーザ編集画面へのリンクが存在する' do
        expect(page).to have_link '', href: edit_user_path(user)
      end
      #**********************************************************************
      # title, opinionを入力するフォームと、Create Bookボタンが表示されている
      #**********************************************************************
      it 'titleフォームが表示される' do
        expect(page).to have_field 'book[title]'
      end
      it 'titleフォームに値が入っていない' do
        expect(find_field('book[title]').text).to be_blank
      end
      it 'opinionフォームが表示される' do
        expect(page).to have_field 'book[body]'
      end
      it 'opinionフォームに値が入っていない' do
        expect(find_field('book[body]').text).to be_blank
      end
      it 'Create Bookボタンが表示される' do
        expect(page).to have_button 'Create Book'
      end

      context '投稿成功のテスト' do
        before do
          fill_in 'book[title]', with: Faker::Lorem.characters(number: 5)
          fill_in 'book[body]', with: Faker::Lorem.characters(number: 20)
        end

        it '自分の新しい投稿が正しく保存される' do
          expect { click_button 'Create Book' }.to change(user.books, :count).by(1)
        end
      end

      context '投稿データの新規投稿失敗' do
        before do
          @body = Faker::Lorem.characters(number: 19)
          fill_in 'book[body]', with: @body
        end

        it '投稿が保存されない' do
          expect { click_button 'Create Book' }.not_to change(Book.all, :count)
        end
        it 'バリデーションエラーが表示される' do
          click_button 'Create Book'
          expect(page).to have_content "can't be blank"
        end
      end

    end
  end

  #***************************************************************************************
  # ログイン時、ヘッダーに"Home", "Users", "Books", "Log Out"のリンクから
  # 「トップページ」「ユーザーの一覧画面」「投稿された本一覧画面」「ログアウト処理」にリダイレクトしている
  #***********************************************************************************************************
  describe 'ヘッダーのテスト: ログインしている場合' do
    context '表示内容の確認' do
      it 'タイトルが表示される' do
        expect(page).to have_content 'Bookers'
      end
      it 'Homeリンクが表示される: 左上から1番目のリンクが「Home」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/home/i)
      end
      it 'Usersリンクが表示される: 左上から2番目のリンクが「Users」である' do
        users_link = find_all('a')[2].native.inner_text
        expect(users_link).to match(/users/i)
      end
      it 'Booksリンクが表示される: 左上から3番目のリンクが「Books」である' do
        books_link = find_all('a')[3].native.inner_text
        expect(books_link).to match(/books/i)
      end
      it 'log outリンクが表示される: 左上から4番目のリンクが「logout」である' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match(/logout/i)
      end
    end
    
    context 'リンクの内容を確認: ※logoutは『ユーザログアウトのテスト』でテスト済みになります。' do
      subject { current_path }

      it 'Homeを押すと、自分のユーザ詳細画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Usersを押すと、ユーザ一覧画面に遷移する' do
        users_link = find_all('a')[2].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/users'
      end
      it 'Booksを押すと、投稿一覧画面に遷移する' do
        books_link = find_all('a')[3].native.inner_text
        books_link = books_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link books_link
        is_expected.to eq '/books'
      end
    end
    
    describe 'ユーザログアウトのテスト' do
      # let(:user) { create(:user) }
  
      before do
        # visit new_user_session_path
        # fill_in 'user[name]', with: user.name
        # fill_in 'user[password]', with: user.password
        # click_button 'Log in'
        logout_link = find_all('a')[4].native.inner_text
        logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link logout_link
      end
  
      context 'ログアウト機能のテスト' do
        it 'ログアウト後のリダイレクト先が、トップになっている' do
          expect(current_path).to eq '/'
        end
      end
    end
  end
  #***********************************
  #user/index
  describe 'ユーザ一覧画面のテスト' do
    before do
      visit users_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users'
      end
      #*******************************************************
      # 自分(ログインしているユーザー)の名前と画像が表示される
      #*******************************************************
      it '自分と他人の画像が表示される: fallbackの画像がサイドバーの1つ＋一覧(2人)の2つの計3つ存在する' do
        expect(all('img').size).to eq(3)
      end
      #*******************************************************************
      # 自分以外(自分でログインしていないユーザー)の名前と画像が表示される
      #*******************************************************************
      it '自分と他人の名前がそれぞれ表示される' do
        expect(page).to have_content user.name
        expect(page).to have_content other_user.name
      end
      #***************************************************
      # ユーザーごとにshowリンクが表示される
      #***************************************************
      it '自分と他人のshowリンクがそれぞれ表示される' do
        expect(page).to have_link 'Show', href: user_path(user)
        expect(page).to have_link 'Show', href: user_path(other_user)
      end
    end

    include_context 'サイドバーの確認'

  end
  #*********************************
  # user/show
  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      #********************************************************************
      # 投稿一覧に投稿したユーザーの名前と画像、本のtitle,opinionが表示される
      # 投稿一覧の本のtitleにリンクがあり、本の詳細画面へリダイレクトできる
      # 投稿一覧のユーザーの画像にリンクがあり、ユーザーの詳細画面へリダイレクトできる
      #*********************************************************************
      it '投稿一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '投稿一覧に自分の投稿のtitleが表示され、リンクが正しい' do
        expect(page).to have_link book.title, href: book_path(book)
      end
      it '投稿一覧に自分の投稿のopinionが表示される' do
        expect(page).to have_content book.body
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_book.title
        expect(page).not_to have_content other_book.body
      end
    end

    include_context 'サイドバーの確認'
  end
  #*******************************************
  # user/edit
  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      #*****************************************
      # 名前編集フォームに自分の名前が表示される
      #*****************************************
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      #**********************************
      # 画像編集フォームが表示される
      #**********************************
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[profile_image]'
      end
      #*************************************************
      # 自己紹介編集フォームに自分の自己紹介が表示される
      #**************************************************
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[introduction]', with: user.introduction
      end
      it 'Update Userボタンが表示される' do
        expect(page).to have_button 'Update User'
      end
    end
    #************************************************
    # 必要情報に全て入力されている時、編集に成功する
    #************************************************
    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.introduction
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[introduction]', with: Faker::Lorem.characters(number: 19)
        click_button 'Update User'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'introductionが正しく更新される' do
        expect(user.reload.introduction).not_to eq @user_old_intrpduction
      end
      #***********************************************************
      # 編集に成功した後、ユーザー情報ページにリダイレクトしている
      #***********************************************************
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
    #***********************************************
    # 必要情報が入力されていない場合、編集に失敗する
    #***********************************************
    context '更新失敗のテスト' do
      before do
        @user_old_name = user.name
        @name = Faker::Lorem.characters(number: 1)
        visit edit_user_path(user)
        fill_in 'user[name]', with: @name
        click_button 'Update User'
      end

      it '更新されない' do
        expect(user.reload.name).to eq @user_old_name
      end
    end

  end
  #*************************************************
  # book/index
  describe '投稿一覧画面のテスト' do

    before do
      visit books_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/books'
      end
      #*******************************************************************
      # 自分が投稿した本のtitle, opinionが表示されていて、titleのリンクから本の詳細画面へリダイレクトできる
      # 自分以外が投稿した本のtitle, opinionが表示されていて、titleのリンクから本の詳細画面へリダイレクトできる
      # ユーザーの画像にリンクがあり、ユーザーの詳細画面へリダイレクトできる
      #*******************************************************************
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(book.user)
        expect(page).to have_link '', href: user_path(other_book.user)
      end
      it '自分の投稿と他人の投稿のタイトルのリンク先がそれぞれ正しい' do
        expect(page).to have_link book.title, href: book_path(book)
        expect(page).to have_link other_book.title, href: book_path(other_book)
      end
      it '自分の投稿と他人の投稿のオピニオンが表示される' do
        expect(page).to have_content book.body
        expect(page).to have_content other_book.body
      end
    end

    include_context 'サイドバーの確認'

  end
  #*********************************
  # book/show
  describe '自分の投稿詳細画面のテスト' do

    before do
      visit book_path(book)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/books/' + book.id.to_s
      end
      it '「Book detail」と表示される' do
        expect(page).to have_content 'Book detail'
      end
      #***********************************************************
      # ユーザー画像・名前にリンク先があり、
      # 本の情報を投稿したユーザーの詳細画面へリダイレクトできる
      #***********************************************************
      it 'ユーザ画像・名前のリンク先が正しい' do
        expect(page).to have_link book.user.name, href: user_path(book.user)
      end
      #*******************************
      # 本のtitle, opinionが表示される
      #*******************************
      it '投稿のtitleが表示される' do
        expect(page).to have_content book.title
      end
      it '投稿のopinionが表示される' do
        expect(page).to have_content book.body
      end
      #**************************************************
      # 自分が投稿した本の場合、Editボタンが表示され、
      # クリックすると投稿の編集画面にリダイレクトできる。
      #**************************************************
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link 'Edit', href: edit_book_path(book)
      end
      #*************************************************
      # 自分が投稿した本の場合、Deleteボタンが表示され、
      # クリックすると投稿を削除できる。
      #*************************************************
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link 'Destroy', href: book_path(book)
      end
    end

    include_context 'サイドバーの確認'

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link 'Edit'
        expect(current_path).to eq '/books/' + book.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link 'Destroy'
      end

      it '正しく削除される' do
        expect(Book.where(id: book.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/books'
      end
    end

  end

  describe 'アクセス制限のテスト:' do

    #*******************************************************
    # 自分以外のユーザーのユーザー編集画面にアクセスできない
    #*******************************************************
    context '他人の投稿編集画面' do
      it '遷移できず、投稿一覧画面にリダイレクトされる' do
        visit edit_book_path(other_book)
        expect(current_path).to eq '/books'
      end
    end
    #***********************************************************
    # 自分以外のユーザーが投稿した本の編集画面にアクセスできない
    #***********************************************************
    context '他人のユーザ情報編集画面' do
      it '遷移できず、自分のユーザ詳細画面にリダイレクトされる' do
        visit edit_user_path(other_user)
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end

  end
end