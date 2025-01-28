require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  describe 'グローバルナビゲーション' do
    context '一覧画面に遷移した場合' do
      it 'グローバルナビゲーションが表示される' do
        visit tasks_path
        expect(page).to have_content "Tasks Index"
        expect(page).to have_content "New Task"
      end
    end
  end

  describe 'タスク一覧画面' do
    context '一覧画面に遷移した場合' do
      it '画面タイトルが表示される' do
        visit tasks_path
        expect(page).to have_selector "h1", text: "Tasks Index Page"
      end

      it 'テーブルヘッダーが表示される' do
        visit tasks_path
        expect(page).to have_selector "th", text: "Title"
        expect(page).to have_selector "th", text: "Content"
        expect(page).to have_selector "th", text: "Created_at"
      end

      it 'Show/Edit/Destroyのリンクが表示される' do
        FactoryBot.create(:task)

        visit tasks_path
        expect(page).to have_selector "a", text: "Show", class: "show-task"
        expect(page).to have_selector "a", text: "Edit", class: "edit-task"
        expect(page).to have_selector "a", text: "Destroy", class: "destroy-task"
      end
    end
  end
end