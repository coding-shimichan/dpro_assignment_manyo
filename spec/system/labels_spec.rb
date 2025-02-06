require 'rails_helper'

RSpec.describe 'ラベル管理機能', type: :system do
  let!(:user) {FactoryBot.create(:user)}

  before do
    visit new_session_path
    fill_in "session[email]", with: user.email
    fill_in "session[password]", with: user.password
    click_on "create-session"
  end

  describe '登録機能' do
    context 'ラベルを登録した場合' do
      it '登録したラベルが表示される' do
        label_name = "User #{user.id} label"
        visit new_label_path
        fill_in "label[name]", with: label_name
        click_on "create-label"

        expect(page).to have_selector "td", text: label_name
      end
    end
  end

  describe '一覧表示機能' do
    context '一覧画面に遷移した場合' do
      it '登録済みのラベル一覧が表示される' do
        visit labels_path
        expect(page).to have_selector "#labels-table"

        label_count = user.labels.length
        label_names = all(".label-name").map(&:text)
        expect(label_count).to eq label_names.length
      end
    end
  end
end
