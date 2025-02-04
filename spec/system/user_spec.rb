require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  let!(:user) {FactoryBot.create(:user)}
  let!(:admin) {FactoryBot.create(:admin_user)}

  describe '登録機能' do
    context 'ユーザを登録した場合' do
      it 'ユーザ一覧画面に遷移する' do
        visit new_session_path
        fill_in "session[email]", with: admin.email
        fill_in "session[password]", with: admin.password
        click_on "create-session"

        visit new_admin_user_path
        fill_in "user[name]", with: "User 2"
        fill_in "user[email]", with: "user2@gmail.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_on "create-user"

        expect(page).to have_selector "h1", text: I18n.t("admin.users.index.title")
      end
    end

    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path

        expect(page).to have_selector "h1", text: I18n.t("sessions.new.title")
        expect(page).to have_content I18n.t("errors.messages.login_required")
      end
    end
  end

  describe 'ログイン機能' do
    context '登録済みのユーザでログインした場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"
      end

      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
        expect(page).to have_content I18n.t("sessions.create.created")
      end

      it '自分の詳細画面にアクセスできる' do
        visit user_path(user.id)
        expect(page).to have_selector "h1", text: I18n.t("users.show.title")
      end

      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(admin.id)
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end

      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_on "sign-out"
        expect(page).to have_content I18n.t("sessions.destroy.destroyed")
      end
    end
  end

  describe '管理者機能' do
    context '管理者がログインした場合' do
      before do
        visit new_session_path
        fill_in "session[email]", with: admin.email
        fill_in "session[password]", with: admin.password
        click_on "create-session"
      end

      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_selector "h1", text: I18n.t("admin.users.index.title")
      end

      it '管理者を登録できる' do
        visit new_admin_user_path
        fill_in "user[name]", with: "User 3"
        fill_in "user[email]", with: "user3@gmail.com"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        check "user[admin]"
        click_on "create-user"

        expect(page).to have_selector "h1", text: I18n.t("admin.users.index.title")
      end

      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_user_path(user.id)
        expect(page).to have_selector "h1", text: I18n.t("admin.users.show.title")
      end

      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(user.id)
        fill_in "user[name]", with: "New name"
        fill_in "user[password]", with: "password"
        fill_in "user[password_confirmation]", with: "password"
        click_on "update-user"
        expect(page).to have_content I18n.t("admin.users.update.updated")
      end

      it 'ユーザを削除できる' do
        visit admin_users_path
        page.accept_confirm(I18n.t("helpers.confirm")) do
          page.find_link(I18n.t("helpers.destroy"), href: admin_user_path(user.id)).click
        end
        expect(page).to have_content I18n.t("admin.users.destroy.destroyed")
      end
    end

    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit new_session_path
        fill_in "session[email]", with: user.email
        fill_in "session[password]", with: user.password
        click_on "create-session"

        visit admin_users_path
        expect(page).to have_content I18n.t("errors.messages.admin_privileges_required")
        expect(page).to have_selector "h1", text: I18n.t("tasks.index.title")
      end
    end
  end
end
