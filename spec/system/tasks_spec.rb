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
end